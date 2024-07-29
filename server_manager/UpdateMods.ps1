<# 
.SYNOPSIS 
    Script for copying DayZ server mods to the server folder.
    
.DESCRIPTION 
    This script copies DayZ mods to the DayZ server folder, ensuring necessary folders exist.
    
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

# Function to ensure necessary folders exist
function EnsureFolders {
    $keysFolder = "$serverFolder\Keys"

    if (!(Test-Path $keysFolder)) {
        New-Item -Path $keysFolder -ItemType Directory
    }
}

# Function to copy mods to the server folder
function CopyMods {
    # Check if DayZ server folder exists
    if (!(Test-Path "$serverFolder")) {
        Write-Output "DayZServer folder does not exist! Please provide a valid server folder path."
        return
    }

    # Check if mod list file exists
    if (!(Test-Path "$modListPath")) {
        Write-Output "Mod list file does not exist! Please provide a valid path."
        return
    }

    # Ensure necessary folders exist
    EnsureFolders

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
            $keysPath = "$serverFolder\Keys"

            # Check if the source path exists
            if (Test-Path "$sourcePath") {
                Write-Output "Copying $modName to $serverFolder"
                # Copy mod folder to server folder, overwriting existing ones
                Copy-Item -Path "$sourcePath\*" -Destination "$destinationPath" -Recurse -Force
                Write-Output "Copied $modName to $serverFolder"

                # Copy key files if they exist
                $keyFiles = Get-ChildItem -Path "$sourcePath" -Filter "*.bikey" -Recurse
                foreach ($keyFile in $keyFiles) {
                    $keyFileName = [System.IO.Path]::GetFileName($keyFile.FullName)
                    $keyFileDest = "$keysPath\$keyFileName"
                    if (Test-Path -Path $keyFileDest -PathType Leaf) {
                        Remove-Item -Path $keyFileDest -Force
                    }
                    Copy-Item -Path $keyFile.FullName -Destination "$keysPath" -Force
                }
                Write-Output "Copied key files for $modName to $serverFolder\Keys"
            } else {
                Write-Output "Source mod folder does not exist: $sourcePath"
            }
        } else {
            Write-Output "Invalid format in mod list: $mod"
        }
    }

    Write-Output "Mod copy completed."
}

# Main function to copy mods
function Main {
    Write-Output "Starting mod copy process..."
    CopyMods
    Write-Output "Process completed."
}

# Call the main function
Main
