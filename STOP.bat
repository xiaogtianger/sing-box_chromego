@echo off

:: Check if running with administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" && (
    echo Running with administrator privileges...
) || (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%comspec%' -ArgumentList '/c \"%~0\"' -Verb RunAs"
    exit /b
)

tasklist /FI "IMAGENAME eq sing-box.exe" 2>NUL | find /I /N "sing-box.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Sing-box is running. Terminating...
    taskkill /F /IM sing-box.exe >NUL
    if not errorlevel 1 (
        echo Sing-box has been terminated.
    ) else (
        echo Error occurred while terminating Sing-box.
    )
) else (
    echo Sing-box is not running.
)

pause
