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
set serverCPU=4
::Sets title for terminal (DONT edit)
title %serverName% batch
::DayZServer location (DONT edit)
cd "%serverLocation%"
echo (%time%) %serverName% started.
::Launch parameters (edit end: -config=|-port=|-profiles=|-doLogs|-adminLog|-netLog|-freezeCheck|-filePatching|-BEpath=|-cpuCount=)
start "DayZ Server" /min "DayZServer_x64.exe" -config=%serverConfig% -port=2302 "-profiles=config" "-mod=@Inventory Move Sounds;@ViewInventoryAnimation;@TF-FuelPump;@Gas-Pump-Refueling;@DrugsPLUS;@dzr_notes;@InventoryPlusPlus;@Juggernaut Armor;@DBN_FordRaptor_Scorpio;@BulletStacksPlusPlusEnhanced;@TangoMedievalPack;@CannabisPlus;@DayZ-Dog;@dbo_raptors;@Community-Online-Tools;@Unlimited Stamina;@DayZ Editor Loader;@DayZOresAndGems;@DayZ-Expansion-Bundle;@MMG - Mightys Military Gear;@SNAFU Weapons;@DayZ-Expansion-Licensed;@Furniture;@InventoryInCar;@Dabs Framework;@CF;" -cpuCount=%serverCPU% -dologs -adminlog -netlog -freezecheck