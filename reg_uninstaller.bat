@echo off
:: Delete the registry key
reg delete "HKEY_CURRENT_USER\Software\Google\Chrome\NativeMessagingHosts\com.foss.ytdlp" /f

echo FOSS Grabber registry files have been completely removed!
pause