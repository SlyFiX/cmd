@echo off
cd /d %~dp0

:: Set the download URL and file name
set MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi
set MSI_FILE=genesys-cloud-windows-2.41.817.msi
set INSTALL_DIR=C:\Users\Public

:: Create download directory if it doesn't exist
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Download the MSI file using curl
echo Downloading Genesys Cloud installer...
curl -L -o "%INSTALL_DIR%\%MSI_FILE%" "%MSI_URL%"

if not exist "%INSTALL_DIR%\%MSI_FILE%" (
    echo Download failed.
    pause
    exit /b 1
)

:: Run the MSI installer and show progress
echo Running Genesys Cloud installer...
msiexec /i "%INSTALL_DIR%\%MSI_FILE%" /L*v "%INSTALL_DIR%\install.log"

echo Installation completed. Check the log at "%INSTALL_DIR%\install.log".
pause
