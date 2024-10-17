@echo off

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell.exe -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:start
taskkill /im DayZServer_x64.exe /F
:: Time in seconds to wait before..
timeout 10

echo Performing git pull to update the repository...
cd "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
git pull

echo Copying mods to appropriate folder...
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\UpdateMods.ps1"

echo Copying Updated Server files to appropriate folder...
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\server_manager\ServerUpdate.ps1"

:: Server name (This is just for the bat file)
set serverName=Natures Weavers
:: Server files location
set serverLocation="C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
:: Server Port
set serverPort=2302
:: Server config
set serverConfig=config.cfg
:: Logical CPU cores to use (Equal or less than available)
set serverCPU=8
:: Sets title for terminal (DONT edit)
title %serverName% batch
:: DayZServer location (DONT edit)
cd "%serverLocation%"
echo (%time%) %serverName% started.

:: Launch parameters (edit end: -config=|-port=|-profiles=|-doLogs|-adminLog|-netLog|-freezeCheck|-filePatching|-BEpath=|-cpuCount=)
start "DayZ Server" /min "DayZServer_x64.exe" -config=%serverConfig% -port=%serverPort% "-profiles=config" "-mod=@QuickMoveItemsByCategory;@Survivor Animations;@DayZ Horse;@Winter Chernarus V2;@Fast Travel;@Techs 4x4 All Terrain Vehicles;@dbo_creatures;@CJ187-LootChest;@Custom Keycards;@Code Lock;@BaseBuildingPlus;@BBPWallpaperBeerGarden;@BBPItemPack;@PvZmoD_TheDarkHorde;@KillAssets;@FlipTransport;@DrugsPLUS;@dzr_notes;@Juggernaut Armor;@BulletStacksPlusPlusEnhanced;@GunnerTruckOshkosh;@GRW ER7 Gauss Rifle;@TangoMedievalPack;@CannabisPlus;@DayZ-Dog;@Community-Online-Tools;@DayZ Editor Loader;@DayZOresAndGems;@MMG - Mightys Military Gear;@MMG Base Storage;@SNAFU Weapons;@DayZ-Expansion-Licensed;@DayZ-Expansion-Bundle;@InventoryInCar;@Dabs Framework;@CF;@Natures Weavers;" -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck

timeout 300

:start
:: Change to the BEC directory
cd "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\BEC"

:: Run BEC with the desired command
BEC.exe -f Config.cfg --dsc