@echo off
setlocal enabledelayedexpansion

:: ===== ENABLE ANSI COLORS =====
for /f "tokens=2 delims=[]" %%i in ('ver') do set ver=%%i
set "ansiSupported=false"
if "%ver:~0,1%"=="1" set "ansiSupported=true"

:: Colors
set "ESC="
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "YELLOW=%ESC%[93m"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

:: ===== VARIABLES =====
set "MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi"
set "MSI_FILE=C:\Users\Public\genesys-cloud-windows-2.41.817.msi"
set "LOG_FILE=C:\Users\Public\genesys_install.log"

:: ===== START TIME =====
set "START_TIME=%time%"
echo %CYAN%=========================================================%RESET%
echo %CYAN%[START] Genesys Cloud Auto Installer%RESET%
echo %CYAN%=========================================================%RESET%
echo Start time: %START_TIME%
echo.

:: ===== DOWNLOAD =====
echo %YELLOW%[1/4] Downloading installer to: %MSI_FILE%...%RESET%
curl -L -o "%MSI_FILE%" "%MSI_URL%"
if not exist "%MSI_FILE%" (
    echo %RED%[ERROR] Download failed. Exiting.%RESET%
    pause
    exit /b 1
)
echo %GREEN%[OK] Download complete.%RESET%
echo.

:: ===== KILL RUNNING PROCESSES =====
echo %YELLOW%[2/4] Closing any running Genesys Cloud instances...%RESET%
taskkill /F /IM "GenesysCloud.exe" >nul 2>&1
echo %GREEN%[OK] All instances closed (if any).%RESET%
echo.

:: ===== INSTALL =====
echo %YELLOW%[3/4] Installing Genesys Cloud (this may take a moment)...%RESET%
powershell -NoProfile -Command ^
    "Start-Process msiexec -ArgumentList '/i \"%MSI_FILE%\" /qn /norestart /log \"%LOG_FILE%\"' -Wait"
echo %GREEN%[OK] Installation complete.%RESET%
echo Log file saved at: %LOG_FILE%
echo.

:: ===== TIME CALCULATION =====
set "END_TIME=%time%"
call :GetElapsedTime "%START_TIME%" "%END_TIME%"
echo %YELLOW%[4/4] All tasks completed.%RESET%
echo %CYAN%Elapsed time: %ELAPSED_TIME%%RESET%
echo %CYAN%=========================================================%RESET%
echo %GREEN%[DONE] Genesys Cloud install script finished.%RESET%
echo %CYAN%=========================================================%RESET%
pause
exit /b 0

:: ===== FUNCTION: Get Elapsed Time =====
:GetElapsedTime
set "start=%~1"
set "end=%~2"
for /f "tokens=1-4 delims=:.," %%a in ("%start%") do (
    set /a startsec=(((1%%a%%b%%c%%d - 100000000) / 10000) * 60 * 60 + (1%%b%%c%%d - 1000000) / 100 + (1%%c%%d - 10000) / 1)
)
for /f "tokens=1-4 delims=:.," %%a in ("%end%") do (
    set /a endsec=(((1%%a%%b%%c%%d - 100000000) / 10000) * 60 * 60 + (1%%b%%c%%d - 1000000) / 100 + (1%%c%%d - 10000) / 1)
)
set /a elapsedsec=%endsec% - %startsec%
set /a mins=%elapsedsec% / 60
set /a secs=%elapsedsec% %% 60
set "ELAPSED_TIME=!mins! minutes and !secs! seconds"
exit /b
