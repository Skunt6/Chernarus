<# 
.SYNOPSIS 
    Script for copying specific DayZ server files to the server folder.
    
.DESCRIPTION 
    This script copies the necessary server files (only the specified ones) to the DayZ server folder, ensuring the necessary folders exist. It ensures files and folders are correctly overwritten instead of being nested.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
    
#> 

# Path to DayZ server installation folder
$serverFolder = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
# Path to the source of the updated server files
$sourceFolder = "C:\Program Files (x86)\Steam\steamapps\common\DayZServer"

# Function to ensure necessary folders exist
function EnsureFolders {
    if (!(Test-Path $serverFolder)) {
        New-Item -Path $serverFolder -ItemType Directory
    }
}

# Function to copy specific server files to the server folder
function CopyServerFiles {
    # Ensure necessary folders exist
    EnsureFolders

    # List of specific files and folders to copy
    $itemsToCopy = @("addons", "battleye", "bliss", "dta", "dayz.gproj", "DayZServer_x64.exe", "steam_api64.dll", "steamclient64.dll", "tier0_s64.dll", "vstdlib_s64.dll")

    # Loop through each item and copy to the server folder
    foreach ($item in $itemsToCopy) {
        $sourcePath = Join-Path -Path $sourceFolder -ChildPath $item
        $destinationPath = Join-Path -Path $serverFolder -ChildPath $item

        # Check if the source path exists
        if (Test-Path "$sourcePath") {
            Write-Output "Copying $item to $serverFolder"
            # Copy item to server folder, ensuring it overwrites the existing one
            Copy-Item -Path "$sourcePath\*" -Destination "$destinationPath" -Recurse -Force
            Write-Output "Copied $item to $serverFolder"
        } else {
            Write-Output "Source item does not exist: $sourcePath"
        }
    }

    Write-Output "Server files copy completed."
}

# Main function to copy server files
function Main {
    Write-Output "Starting server files copy process..."

    # Copy updated server files to the server folder
    CopyServerFiles

    Write-Output "Process completed."
}

# Call the main function
Main
