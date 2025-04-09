@echo off
cd /d %~dp0

:: Define the installation location and MSI file details
set DOWNLOAD_DIR=C:\Users\Public
set MSI_NAME=genesys-cloud-windows-2.41.817.msi
set MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/%MSI_NAME%
set LOG_FILE=%DOWNLOAD_DIR%\install.log

:: Create download directory if it doesn't exist
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
)

echo Downloading Genesys Cloud installer...
curl -L -o "%DOWNLOAD_DIR%\%MSI_NAME%" "%MSI_URL%"

if not exist "%DOWNLOAD_DIR%\%MSI_NAME%" (
    echo Download failed.
    pause
    exit /b 1
)

echo.
echo Checking if Genesys Cloud is already installed...

:: Uninstall previous version if installed (use GUID if available)
echo Attempting to uninstall any previous versions of Genesys Cloud...
msiexec /x {PRODUCT-CODE-GUID} /qn /norestart

:: Wait for a few seconds before proceeding
timeout /t 5

echo Running Genesys Cloud installer...

:: Run the installer and make the process visible in the CMD
msiexec /i "%DOWNLOAD_DIR%\%MSI_NAME%" REINSTALL=ALL REINSTALLMODE=vomus /L*v "%LOG_FILE%"

echo.
echo If no errors appeared, the update is now running in the background.
echo Log written to: %LOG_FILE%
pause

:: Check the log for errors
echo Checking installation log...
notepad "%LOG_FILE%"
