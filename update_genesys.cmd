@echo off
cd /d %~dp0

set MSI_NAME=genesys-cloud-windows-2.41.817.msi
set MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/%MSI_NAME%
set LOG_FILE=%CD%\install.log

echo Downloading Genesys Cloud installer...
curl -L -o "%MSI_NAME%" "%MSI_URL%"

if not exist "%MSI_NAME%" (
    echo Download failed.
    pause
    exit /b 1
)

echo.
echo Running installer as current user (make sure this window is running as administrator)...
msiexec /i "%CD%\%MSI_NAME%" /qn /norestart REINSTALL=ALL REINSTALLMODE=vomus /L*v "%LOG_FILE%"

echo.
echo If no errors appeared, the update is now running in the background.
echo Log written to: %LOG_FILE%
pause
