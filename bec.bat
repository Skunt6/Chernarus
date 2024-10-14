@echo off

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell.exe -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: Change to the BEC directory
cd "C:\Users\rt603\Desktop\projects\Dayz-servers\Chernarus\BEC"

:: Run BEC with the desired command
BEC.exe -f Config.cfg --dsc
