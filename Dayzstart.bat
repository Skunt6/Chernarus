@echo off
:start
taskkill /im DayZServer_x64.exe /F
::Time in seconds to wait before..
timeout 10
::Server name (This is just for the bat file)
set serverName=Natures Weavers
::Server files location
set serverLocation="C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus"
::Server Port
set serverPort=2302
::Server config
set serverConfig=config.cfg
::Logical CPU cores to use (Equal or less than available)
set serverCPU=8
::Sets title for terminal (DONT edit)
title %serverName% batch
::DayZServer location (DONT edit)
cd "%serverLocation%"
echo (%time%) %serverName% started.
::Launch parameters (edit end: -config=|-port=|-profiles=|-doLogs|-adminLog|-netLog|-freezeCheck|-filePatching|-BEpath=|-cpuCount=)
start "DayZ Server" /min "DayZServer_x64.exe" -config=%serverConfig% -port=2302 "-profiles=config" "-mod=@Techs 4x4 All Terrain Vehicles;@NaturesWeavers;@CJ187-LootChest;@Custom Keycards;@Code Lock;@BaseBuildingPlus;@BBPWallpaperBeerGarden;@BBPItemPack;@InventoryPlusPlus;@DayZ-Expansion-Bundle;@PvZmoD_TheDarkHorde;@dbo_tigers_02;@KillAssets;@FlipTransport;@Inventory Move Sounds;@ViewInventoryAnimation;@TF-FuelPump;@Gas-Pump-Refueling;@DrugsPLUS;@dzr_notes;@Juggernaut Armor;@DBN_FordRaptor_Scorpio;@BulletStacksPlusPlusEnhanced;@TangoMedievalPack;@CannabisPlus;@DayZ-Dog;@Community-Online-Tools;@Unlimited Stamina;@DayZ Editor Loader;@DayZOresAndGems;@MMG - Mightys Military Gear;@SNAFU Weapons;@DayZ-Expansion-Licensed;@Furniture;@InventoryInCar;@Dabs Framework;@CF;" -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck