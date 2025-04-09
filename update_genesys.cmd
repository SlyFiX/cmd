@echo off
cd /d %~dp0

echo Downloading Genesys Cloud installer...
curl -L -o "genesys-cloud-windows-2.41.817.msi" "https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi"

if not exist "genesys-cloud-windows-2.41.817.msi" (
    echo Download failed.
    pause
    exit /b 1
)

echo.
echo Please enter password for ADMIN when prompted...
runas /user:CALLEXCELL\ADM.VPETROV "cmd /c \"msiexec /i \"%CD%\genesys-cloud-windows-2.41.817.msi\" /qn /norestart REINSTALL=ALL REINSTALLMODE=amus\""

echo.
echo If no errors appeared, the update is now running in the background.
pause
