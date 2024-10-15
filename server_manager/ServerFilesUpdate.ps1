<#
.SYNOPSIS 
    Script for updating DayZ server files using SteamCMD.
    
.DESCRIPTION 
    This script updates DayZ server files using SteamCMD.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
#>

# Path to SteamCMD executable
$steamCMDPath = "C:\Program Files (x86)\Steam\steamcmd.exe"
# DayZ server App ID
$dayzAppID = 223350
# Path to your DayZ server installation folder
$dayzServerPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
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
function Update-DayZServer {
    param (
        [PSCredential]$steamCredentials
    )

    Write-Output "Starting DayZ server update..."

    # Prepare the update command
    $updateCommand = "+force_install_dir `"$dayzServerPath`" +login $($steamCredentials.UserName) $($steamCredentials.GetNetworkCredential().Password) +app_update $dayzAppID validate +quit"

    Write-Output "Executing SteamCMD with the following command:"
    Write-Output $updateCommand

    Start-Process -FilePath "$steamCMDPath" -ArgumentList $updateCommand -Wait -NoNewWindow

    Write-Output "DayZ server update completed."
}

# Main function to update the server
function Main {
    Write-Output "Starting server update process..."

    # Get Steam credentials
    $steamCredentials = Get-SteamCredentials

    # Update DayZ server files
    Update-DayZServer -steamCredentials $steamCredentials

    Write-Output "Process completed."
}

# Call the main function
Main
