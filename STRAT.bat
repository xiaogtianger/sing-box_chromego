@echo off
setlocal enabledelayedexpansion
chcp 1252 > nul

cd /d "%~dp0"

set "subFolder=sub\sub-configs"
set "counter=0"
set "defaultChoice=1"

color 0A
echo.
echo Please choose your config profile:
echo.

for %%F in (%subFolder%\*) do (
    set /a counter+=1
    echo !counter!. %%~nxF
    set "file[!counter!]=%%~dpnxF"
)
echo.

set /p "choice=Choose your choice [Default:!defaultChoice!]: "
if "!choice!"=="" set "choice=!defaultChoice!"
for /f %%A in ("!choice!") do set "choice=%%A"
set "choice=!choice: =!"

if !choice! geq 1 if !choice! leq !counter! (
    set "selectedFile=!file[%choice%]!"
    echo selected file: !selectedFile!
    cd /d "%~dp0%core\"
    set "checkResult="
    call set "checkCommand=sing-box.exe check -c "!selectedFile!" 2>&1"
    for /f "delims=" %%i in ('!checkCommand!') do set "checkResult=%%i"
    if not "!checkResult!"=="" (
        echo "Check failed"
        echo !checkResult!
        pause
    ) else (
        echo Requesting Administrator Privileges...
        powershell -Command "& { Start-Process 'sing-box.exe' -ArgumentList 'run -c "!selectedFile!"' -Verb RunAs -WindowStyle Hidden }"
        start "" "https://yacd.metacubex.one/?hostname=127.0.0.1&port=9090"
        exit /b
    )
    
) else (
    echo Error...
    pause
    exit /b 1
)
