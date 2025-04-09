@echo off
setlocal

set "MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi"
set "MSI_FILE=C:\Users\Public\genesys-cloud-windows-2.41.817.msi"

echo Downloading Genesys Cloud installer...
curl -L -o "%MSI_FILE%" "%MSI_URL%"

if not exist "%MSI_FILE%" (
    echo Download failed.
    pause
    exit /b 1
)

echo.
echo Starting installation in background...
powershell -NoProfile -Command ^
    "Start-Process msiexec -ArgumentList '/i \"%MSI_FILE%\" /quiet /norestart /log \"%TEMP%\genesys_install.log\"' -Wait"

echo.
echo ===== INSTALLATION LOG SUMMARY =====
type "%TEMP%\genesys_install.log" | findstr /i "error installed success fail exit"

echo.
echo Installation complete. Full log: %TEMP%\genesys_install.log
pause
