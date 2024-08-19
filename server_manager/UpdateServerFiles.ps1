<# 
.SYNOPSIS 
    Script for updating DayZ server files using SteamCMD, ensuring installation in the correct directory.
    
.DESCRIPTION 
    This script logs in to Steam to update the DayZ server files using SteamCMD, explicitly setting the install directory.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
    
#> 

# Path to the correct installation directory for DayZ server files
$correctInstallDir = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer"
# Path to SteamCMD executable
$steamCMDPath = "C:\Program Files (x86)\Steam\steamcmd.exe"
# Steam App ID for DayZ Server
$dayzAppID = "223350"
# Path to save Steam credentials
$credentialsPath = "$env:USERPROFILE\steam_credentials.xml"
# Paths to save the SteamCMD logs
$outputLogFile = "$env:USERPROFILE\steamcmd_output_log.txt"
$errorLogFile = "$env:USERPROFILE\steamcmd_error_log.txt"

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

# Function to create the installation directory if it doesn't exist
function EnsureInstallDirExists {
    if (!(Test-Path $correctInstallDir)) {
        Write-Output "Installation directory does not exist. Creating directory..."
        New-Item -Path $correctInstallDir -ItemType Directory
        Write-Output "Directory created: $correctInstallDir"
    } else {
        Write-Output "Installation directory exists: $correctInstallDir"
    }
}

# Function to update DayZ server files using SteamCMD
function UpdateServerFiles {
    Write-Output "Updating DayZ server files using SteamCMD..."
    
    # Get Steam credentials
    $steamCredentials = Get-SteamCredentials
    
    $loginCommand = "+login $($steamCredentials.UserName) $($steamCredentials.GetNetworkCredential().Password)"
    $updateCommand = "+app_update $dayzAppID validate +quit"
    
    # Combine force_install_dir and login commands
    $fullCommand = "+force_install_dir `"$correctInstallDir`" $loginCommand $updateCommand"
    
    # Output the full command for debugging
    Write-Output "Executing SteamCMD with the following command:"
    Write-Output "$fullCommand"
    
    # Execute SteamCMD to update server files and log output
    Start-Process -FilePath "$steamCMDPath" -ArgumentList $fullCommand -Wait -NoNewWindow -RedirectStandardOutput "$outputLogFile" -RedirectStandardError "$errorLogFile"
    
    # Display the log file content
    if (Test-Path $outputLogFile) {
        Write-Output "SteamCMD output log:"
        Get-Content $outputLogFile
    } else {
        Write-Output "SteamCMD output log not found."
    }

    if (Test-Path $errorLogFile) {
        Write-Output "SteamCMD error log:"
        Get-Content $errorLogFile
    } else {
        Write-Output "SteamCMD error log not found."
    }
    
    Write-Output "DayZ server files update completed."

    # Verify that the DayZServer_x64.exe file was updated
    $exePath = Join-Path -Path $correctInstallDir -ChildPath "DayZServer_x64.exe"
    if (Test-Path $exePath) {
        $lastModified = (Get-Item $exePath).LastWriteTime
        Write-Output "DayZServer_x64.exe last modified on: $lastModified"
    } else {
        Write-Output "DayZServer_x64.exe not found at $exePath."
    }
}

# Main function to update server files
function Main {
    Write-Output "Starting server update process..."

    # Ensure installation directory exists
    EnsureInstallDirExists

    # Update server files using SteamCMD
    UpdateServerFiles

    Write-Output "Process completed."
}

# Call the main function
Main
