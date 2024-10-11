@echo off
:check_Permissions
echo Administrative permissions required. Detecting permissions...

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    echo Failure: You need to run this as Admin!!!
    pause
    goto konec
)

echo Copying AppxManifest.xml to C:\Users\
copy "%~dp0AppxManifest.xml" "C:\Users\" >nul
if %errorLevel% neq 0 (
    echo Error: Failed to copy the file. Check the file path and try again.
    pause
    goto konec
)

echo Modifying registry to allow development mode...
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >nul 2>nul

echo Removing Outlook appx package...
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"

echo Registering AppxManifest.xml...
powershell add-appxpackage -register "C:\Users\AppxManifest.xml"

:konec
