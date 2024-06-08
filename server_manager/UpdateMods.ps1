<# 
.SYNOPSIS 
    Script for updating DayZ server mods using SteamCMD and copying them to the server folder.
    
.DESCRIPTION 
    This script downloads DayZ mods using SteamCMD and copies them to the DayZ server folder, overwriting the existing mod folders directly.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
    
#> 

# Path to DayZ server folder
$serverFolder = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
# Path to mod list file
$modListPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\mod_list.txt"
# Path to SteamCMD DayZ Workshop content folder
$workshopFolder = "C:\Program Files (x86)\Steam\steamapps\workshop\content\221100"
# Path to SteamCMD executable
$steamCMDPath = "C:\Program Files (x86)\Steam\steamcmd.exe"
# Path to save Steam credentials
$credentialsPath = "$env:USERPROFILE\steam_credentials.xml"

# Function to get or prompt for Steam credentials
function Get-SteamCredentials {
    if (Test-Path -Path $credentialsPath) {
        $steamCredentials = Import-Clixml -Path $credentialsPath
    } else {
        $steamUsername = Read-Host -Prompt 'Enter your Steam username'
        $steamPassword = Read-Host -Prompt 'Enter your Steam password' -AsSecureString
        $steamCredentials = New-Object PSCredential -ArgumentList $steamUsername, $steamPassword
        $steamCredentials | Export-Clixml -Path $credentialsPath
    }
    return $steamCredentials
}

# Function to check if a mod needs to be updated
function NeedsUpdate($modId, $modName) {
    $sourcePath = "$workshopFolder\$modId"
    $destinationPath = "$serverFolder\$modName"

    if (!(Test-Path "$destinationPath")) {
        # If the destination path doesn't exist, the mod needs to be updated
        return $true
    }

    # Get the latest modification time from the source and destination paths
    $sourceModTime = (Get-ChildItem -Path "$sourcePath" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
    $destinationModTime = (Get-ChildItem -Path "$destinationPath" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime

    # Compare modification times
    if ($sourceModTime -gt $destinationModTime) {
        return $true
    } else {
        return $false
    }
}

# Function to update a single mod using SteamCMD
function UpdateMod {
    param (
        [string]$modId,
        [string]$modName,
        [PSCredential]$steamCredentials
    )

    Start-Process -FilePath "$steamCMDPath" -ArgumentList "+login $($steamCredentials.UserName) $($steamCredentials.GetNetworkCredential().Password) +workshop_download_item 221100 $modId validate +quit" -Wait -NoNewWindow
    Write-Output "Updated mod: $modName"
}

# Function to update mods using SteamCMD
function UpdateMods {
    # Check if mod list file exists
    if (!(Test-Path "$modListPath")) {
        Write-Output "Mod list file does not exist! Please provide a valid path."
        return
    }

    # Load mod list
    $mods = Get-Content "$modListPath"

    # Get Steam credentials
    $steamCredentials = Get-SteamCredentials

    # Create a runspace pool for parallel processing
    $runspacePool = [runspacefactory]::CreateRunspacePool(1, 5)
    $runspacePool.Open()

    $runspaces = @()

    foreach ($mod in $mods) {
        if ($mod -match "(\d+)\s*(#\s*@.*)$") {
            $modId = $matches[1]
            $modName = $matches[2] -replace "#\s*", ""

            if (NeedsUpdate $modId $modName) {
                $runspace = [powershell]::Create().AddScript({
                    param ($modId, $modName, $steamCredentials)
                    UpdateMod -modId $modId -modName $modName -steamCredentials $steamCredentials
                }).AddArgument($modId).AddArgument($modName).AddArgument($steamCredentials)

                $runspace.RunspacePool = $runspacePool
                $runspaces += [PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke() }
            } else {
                Write-Output "Mod $modName is already up to date."
            }
        } else {
            Write-Output "Invalid format in mod list: $mod"
        }
    }

    # Wait for all runspaces to complete
    $runspaces | ForEach-Object {
        $_.Pipe.EndInvoke($_.Status)
        $_.Pipe.Dispose()
    }

    $runspacePool.Close()
    $runspacePool.Dispose()

    Write-Output "Mod download/update completed."
}

# Function to copy mods to the server folder
function CopyMods {
    # Check if DayZ server folder exists
    if (!(Test-Path "$serverFolder")) {
        Write-Output "DayZServer folder does not exist! Run server update before mod update."
        return
    }

    # Check if mod list file exists
    if (!(Test-Path "$modListPath")) {
        Write-Output "Mod list file does not exist! Please provide a valid path."
        return
    }

    # Load mod list
    $mods = Get-Content "$modListPath"

    # Loop through each mod ID in the list and copy to the server folder
    foreach ($mod in $mods) {
        if ($mod -match "(\d+)\s*(#\s*@.*)$") {
            $modId = $matches[1]
            $modName = $matches[2] -replace "#\s*", ""

            # Source and destination paths
            $sourcePath = "$workshopFolder\$modId"
            $destinationPath = "$serverFolder\$modName"

            # Check if the source path exists
            if (Test-Path "$sourcePath") {
                # Copy mod folder to server folder, overwriting existing ones
                Copy-Item -Path "$sourcePath\*" -Destination "$destinationPath" -Recurse -Force
                Write-Output "Copied $modName to $serverFolder"
            } else {
                Write-Output "Source mod folder does not exist: $sourcePath"
            }
        } else {
            Write-Output "Invalid format in mod list: $mod"
        }
    }

    Write-Output "Mod copy completed."
}

# Main function to update and copy mods
function Main {
    UpdateMods
    CopyMods
}

# Call the main function
Main
