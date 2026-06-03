@echo off
setlocal EnableExtensions

echo ===================================================
echo     Downloading SidWinder Engines (yt-dlp & FFmpeg)     
echo ===================================================
echo.

:: 1. Create bin folder if it doesn't exist
if not exist "bin" mkdir bin

:: 2. Download the latest yt-dlp.exe using native curl
echo Downloading yt-dlp.exe (via Mirror CDN)...
curl -L -o bin\yt-dlp.exe "https://mirror.ghproxy.com/https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"

:: 3. Download FFmpeg static build zip using native curl
echo Downloading FFmpeg build...
curl -L -o ffmpeg.zip "https://mirror.ghproxy.com/https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

:: 4. Extract using native Windows tar
echo Extracting FFmpeg files...
tar -xf ffmpeg.zip

:: 5. Dynamically locate the extracted folder and move the executable files
for /d %%i in (ffmpeg-*) do (
    move "%%i\bin\ffmpeg.exe" bin\ >nul
    move "%%i\bin\ffplay.exe" bin\ >nul
    move "%%i\bin\ffprobe.exe" bin\ >nul
    rmdir /s /q "%%i"
)

:: 6. Clean up the downloaded temporary zip file
if exist ffmpeg.zip del ffmpeg.zip

echo.
echo FOSS Engines downloaded and configured inside "bin/" successfully!
pause