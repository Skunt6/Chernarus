<# 
.SYNOPSIS 
    Script for updating DayZ server files using SteamCMD.
    
.DESCRIPTION 
    This script logs in to Steam and updates the DayZ server files using SteamCMD.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
    
#> 

# Path to the source of the updated server files
$sourceFolder = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
# Path to SteamCMD executable
$steamCMDPath = "C:\Program Files (x86)\Steam\steamcmd.exe"
# Steam App ID for DayZ Server
$dayzAppID = "223350"
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

# Function to update DayZ server files using SteamCMD
function UpdateServerFiles {
    Write-Output "Updating DayZ server files using SteamCMD..."
    
    # Get Steam credentials
    $steamCredentials = Get-SteamCredentials
    
    $loginCommand = "+login $($steamCredentials.UserName) $($steamCredentials.GetNetworkCredential().Password)"
    $updateCommand = "+app_update $dayzAppID validate +quit"
    
    # Combine force_install_dir and login commands
    $fullCommand = "+force_install_dir $sourceFolder $loginCommand $updateCommand"
    
    # Execute SteamCMD to update server files
    Start-Process -FilePath "$steamCMDPath" -ArgumentList $fullCommand -Wait -NoNewWindow
    Write-Output "DayZ server files update completed."
}

# Main function to update server files
function Main {
    Write-Output "Starting server update process..."

    # Update server files using SteamCMD
    UpdateServerFiles

    Write-Output "Process completed."
}

# Call the main function
Main
