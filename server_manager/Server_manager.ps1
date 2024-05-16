<#
.SYNOPSIS
    Script for managing and updating a DayZ server and its mods.

.DESCRIPTION
    This script can be used for downloading and managing the DayZ server and mods via SteamCMD.
    It also provides the ability to restart the DayZ server after updates.

.NOTES
    File Name   : Server_manager.ps1
    Author      : Bohemia Interactive a.s.
    Modified by : User (based on specific requirements)
    Requires    : PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer

.LINK
    DayZ web      : https://dayz.com/
    DayZ Wiki     : https://community.bistudio.com/wiki/DayZ:Server_manager

.PARAMETER update
    Updates both DayZ server and mods to the latest version.

.PARAMETER restart
    Restarts the DayZ server after updates.

.EXAMPLE
    Update both server and mods, and restart server afterward:
    C:\foo> .\Server_manager.ps1 -update -restart

© 2018 Bohemia Interactive a.s. (Modified by User)
All rights reserved.
#>

# Parameters
param (
    [switch] $update = $false,
    [switch] $restart = $false
)

# Configuration
$steamCmdPath = "C:\Program Files (x86)\Steam\steamcmd.exe"
$installDir = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
$modListPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\mod_list.txt"
$serverModListPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\server_mod_list.txt"
$dayzServerExe = "$installDir\DayZServer_x64.exe"

# Function to update DayZ server
function Update-DayZServer {
    Write-Output "Updating DayZ server..."
    & "$steamCmdPath" + " +login anonymous +force_install_dir `"$installDir`" +app_update 223350 validate +quit"
}

# Function to update mods
function Update-Mods {
    Write-Output "Updating DayZ mods..."

    # Update regular mods
    $modIDs = Get-Content "$modListPath"
    foreach ($mod in $modIDs) {
        & "$steamCmdPath" + " +login anonymous +workshop_download_item 221100 $mod validate +quit"
    }

    # Update server mods
    $serverModIDs = Get-Content "$serverModListPath"
    foreach ($serverMod in $serverModIDs) {
        & "$steamCmdPath" + " +login anonymous +workshop_download_item 221100 $serverMod validate +quit"
    }
}

# Function to start DayZ server
function Start-DayZServer {
    Write-Output "Starting DayZ server..."
    Start-Process -FilePath "$dayzServerExe" -ArgumentList ("-config=serverDZ.cfg", "-profiles=logs", "-port=2302") -NoNewWindow
}

# Function to stop running DayZ server instances
function Stop-DayZServer {
    Write-Output "Stopping DayZ server instances..."
    Get-Process -Name "DayZServer_x64" -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Execution logic
if ($update) {
    # Stop server, update both server and mods, then restart the server
    Stop-DayZServer
    Update-DayZServer
    Update-Mods

    if ($restart) {
        Start-DayZServer
    }
} else {
    Write-Output "Usage: .\Server_manager.ps1 -update -restart"
}

Write-Output "DayZ server management completed."
