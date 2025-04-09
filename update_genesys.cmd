@echo off
:: Ensure the script is run via PowerShell with Administrator privileges

:: Path to the PowerShell script to execute the MSI installation
set "PS_SCRIPT=C:\Users\Public\install_genesys_cloud.ps1"

:: Create the PowerShell script file that will run the MSI with elevated privileges
echo $ErrorActionPreference = 'Stop' > "%PS_SCRIPT%"
echo Start-Process "msiexec.exe" -ArgumentList "/i", "C:\Users\Public\genesys-cloud-windows-2.41.817.msi", "/qn", "/norestart" -Verb runAs >> "%PS_SCRIPT%"

:: Download MSI file
echo Downloading Genesys Cloud MSI...
curl -L -o "C:\Users\Public\genesys-cloud-windows-2.41.817.msi" "https://app.mypurecloud.com/directory-windows/build-assets/2.41.817-118/genesys-cloud-windows-2.41.817.msi"

:: Check if MSI was downloaded
if not exist "C:\Users\Public\genesys-cloud-windows-2.41.817.msi" (
    echo Download failed. Exiting...
    pause
    exit /b 1
)

:: Execute the PowerShell script with runAs to ensure it runs as Administrator
echo Running installation with administrator privileges...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

:: Cleanup by removing the temporary PowerShell script
del "%PS_SCRIPT%"

pause
