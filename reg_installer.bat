@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ===================================================
echo      Project FOSS Control Overlord - Installer      
echo ===================================================
echo.
set /p EXT_ID="Please paste your Chrome Extension ID: "
echo.

:: Get current folder path and replace single backslashes with double backslashes for JSON
set "CURRENT_DIR=%~dp0"
set "JSON_DIR=!CURRENT_DIR:\=\\!"

:: Dynamically generate the com.foss.ytdlp.json file with the user's specific Extension ID
(
echo {
echo   "name": "com.foss.ytdlp",
echo   "description": "Chrome Native Messaging Host for yt-dlp",
echo   "path": "!JSON_DIR!bridge.bat",
echo   "type": "stdio",
echo   "allowed_origins": [
echo     "chrome-extension://!EXT_ID!/"
echo   ]
echo }
) > "%~dp0com.foss.ytdlp.json"

:: Write registry entry pointing to the newly generated json
reg add "HKEY_CURRENT_USER\Software\Google\Chrome\NativeMessagingHosts\com.foss.ytdlp" /ve /d "%~dp0com.foss.ytdlp.json" /f

echo.
echo FOSS Grabber registered successfully with Extension ID: !EXT_ID!
pause