@echo off
:check_Permissions
echo Administrative permissions required. Detecting permissions...

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    echo Failure: You need to run this as Admin!!!
    pause
    goto end
)

:menu
echo Select an option:
echo 1. Spoof Outlook installation
echo 2. Remove modifications
echo 3. Exit
set /p choice=Enter your choice (1-3): 

if "%choice%" == "1" goto spoof
if "%choice%" == "2" goto remove
if "%choice%" == "3" goto end


echo Invalid choice. Please try again.
goto menu

:spoof
echo Copying AppxManifest.xml to C:\Users\
copy "%~dp0AppxManifest.xml" "C:\Users\" >nul
if %errorLevel% neq 0 (
    echo Error: Failed to copy the file. Check the file path and try again.
    pause
    goto end
)

echo Enabling development mode...
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >nul 2>nul

echo Removing Outlook appx package...
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"

echo Registering AppxManifest.xml...
powershell add-appxpackage -register "C:\Users\AppxManifest.xml"

echo Disabling development mode...
powershell "Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue"

echo Spoofing completed.
pause
goto menu

:remove
echo Removing AppxManifest.xml from C:\Users\...
if exist "C:\Users\AppxManifest.xml" (
    del "C:\Users\AppxManifest.xml" >nul 2>&1
    if %errorLevel% neq 0 (
        echo Warning: File "C:\Users\AppxManifest.xml" could not be deleted.
        pause
        goto end
    )
) else (
    echo File "C:\Users\AppxManifest.xml" not found. Continuing...
)

echo Enabling development mode...
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >nul 2>nul

echo Removing spoofed package...
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers" >nul 2>nul

echo Disabling development mode...
powershell "Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue"


echo Restoration completed. Please, restart your computer!
echo To use New Outlook, let it download from Mail ^& Calendar or Outlook Classic after you restarted.
pause
goto menu

:end
exit
