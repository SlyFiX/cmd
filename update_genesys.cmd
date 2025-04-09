@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem ===============================
rem =   Genesys Cloud Updater    =
rem ===============================

set "MSI_URL=https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi"
set "MSI_FILE=C:\Users\Public\genesys-cloud-windows-2.41.817.msi"
set "LOG_FILE=%TEMP%\genesys_install.log"

rem Record start time
for /f "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
    set "START_HH=%%a"
    set "START_MM=%%b"
    set "START_SS=%%c"
    set "START_MS=%%d"
)

echo ===========================================
echo   [START] Genesys Cloud Update Process
echo   [%DATE% %TIME%]
echo ===========================================
echo.

echo [1/3] Downloading installer to: %MSI_FILE%
curl -L -o "%MSI_FILE%" "%MSI_URL%"
if not exist "%MSI_FILE%" (
    echo [ERROR] Download failed. Exiting.
    pause
    exit /b 1
)
echo [OK] Download complete.
echo.

echo [2/3] Launching silent installer...
powershell -NoProfile -Command ^
    "Start-Process msiexec -ArgumentList '/i \"%MSI_FILE%\" /quiet /norestart /log \"%LOG_FILE%\"' -Wait"
echo [OK] Installation completed.
echo.

echo [3/3] Parsing log summary:
echo -------------------------------------------
type "%LOG_FILE%" | findstr /i "error installed success fail exit"
echo -------------------------------------------
echo.

rem ===============================
rem =    Time Elapsed Section    =
rem ===============================
for /f "tokens=1-4 delims=:.," %%a in ("%TIME%") do (
    set "END_HH=%%a"
    set "END_MM=%%b"
    set "END_SS=%%c"
    set "END_MS=%%d"
)

rem Convert times to milliseconds
set /a "START_TOTAL=((1%START_HH%-100)*3600000) + (%START_MM%*60000) + (%START_SS%*1000) + %START_MS%"
set /a "END_TOTAL=((1%END_HH%-100)*3600000) + (%END_MM%*60000) + (%END_SS%*1000) + %END_MS%"
set /a "ELAPSED=%END_TOTAL% - %START_TOTAL%"

set /a "ELAPSED_SEC=%ELAPSED% / 1000"
set /a "ELAPSED_MIN=%ELAPSED_SEC% / 60"
set /a "REMAIN_SEC=%ELAPSED_SEC% %% 60"

echo Total time elapsed: %ELAPSED_MIN% min %REMAIN_SEC% sec

echo.
echo ===========================================
echo   [DONE] Genesys Cloud Update Completed
echo   [%DATE% %TIME%]
echo ===========================================
pause
exit /b
