@echo off
cd /d %~dp0

echo Downloading Genesys Cloud installer...
powershell -Command "Invoke-WebRequest -Uri 'https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi' -OutFile 'genesys-cloud-windows-2.41.817.msi'"

if not exist "genesys-cloud-windows-2.41.817.msi" (
    echo Download failed.
    pause
    exit /b 1
)

echo.
echo Please enter password for .\LocalAdminUser when prompted...
runas /user:.\Dell "msiexec /i \"%CD%\genesys-cloud-windows-2.41.817.msi\" /qn /norestart REINSTALL=ALL REINSTALLMODE=vomus"

echo.
echo If no errors appeared, the update is now running in the background.
pause
