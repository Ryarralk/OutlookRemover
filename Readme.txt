"Outlook" (New) permanent removal script
========================================
This script prevents the Outlook (new) app from installing by installing a custom blank app with the same package id as the original one, thus making it´s installation fail. To do this, it enables the developer mode via registry and registers the modified New Outlook manifest as an unpacked Appx package.

How to use it?
==============
1. Unpack the ZIP file (if you didn´t already)
2. Run the outlook.bat batch file as an Admin
3. DONE! You can now remove the files

How exactly does it work?
=========================
1. Copies the  AppxManifest.xml to the \Users folder
2. Enables developer mode (i.e. sideloading apps) via registry
3. Uninstalls the New Outlook (if present)
4. Installs the fake one
