<# 
.SYNOPSIS 
    Script for updating DayZ server mod folders and keys.
    
.DESCRIPTION 
    This script updates the DayZ server mod folders by copying the downloaded mod folders from SteamCMD and also updates the `keys` folder with the latest `.bikey` files.
    
.NOTES 
    Requires: PowerShell V4
    Supported OS: Windows 10, Windows Server 2012 R2 or newer
    
#>

# Path to mod list file
$modListPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\mod_list.txt"
# Directory where mods are downloaded by SteamCMD
$downloadPath = "C:\Program Files (x86)\Steam\steamapps\workshop\content\221100"
# Path to DayZ server mods folder
$serverModsPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
# Path to DayZ server keys folder
$keysFolderPath = "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\keys"

# Function to replace entire mod folder on the server and update keys
function UpdateModFolders {
    # Check if mod list file exists
    if (!(Test-Path "$modListPath")) {
        Write-Output "Mod list file does not exist! Please provide a valid path."
        return
    }

    # Load mod list
    $mods = Get-Content "$modListPath"

    foreach ($mod in $mods) {
        if ($mod -match "(\d+)\s*#\s*(.*)$") {
            $modId = $matches[1]
            $modName = $matches[2]
            $sourcePath = Join-Path $downloadPath $modId
            $destinationPath = Join-Path $serverModsPath $modName

            if (Test-Path $sourcePath) {
                Write-Output "Updating mod: $modName from $sourcePath to $destinationPath"

                # Remove existing mod folder on the server if it exists
                if (Test-Path $destinationPath) {
                    Remove-Item -Recurse -Force $destinationPath
                    Write-Output "Removed old mod folder: $destinationPath"
                }

                # Copy entire mod folder to server
                Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
                Write-Output "Copied mod folder: $modName to server."

                # Check and copy the `.bikey` files to the `keys` folder
                $keyFiles = Get-ChildItem -Path $sourcePath -Recurse -Filter *.bikey
                foreach ($keyFile in $keyFiles) {
                    Copy-Item -Path $keyFile.FullName -Destination $keysFolderPath -Force
                    Write-Output "Copied key file: $($keyFile.Name) to the keys folder."
                }
            } else {
                Write-Output "Source mod folder does not exist for: $modName"
            }
        } else {
            Write-Output "Invalid format in mod list: $mod"
        }
    }

    Write-Output "All mod folders and keys updated."
}

# Main function to update mod folders
function Main {
    Write-Output "Starting mod folder update process..."

    # Update mod folders and keys
    UpdateModFolders

    Write-Output "Process completed."
}

# Call the main function
Main
