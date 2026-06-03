# SidWinder

## ⚠️ License Notice
This project is **proprietary software**. The source code is publicly visible for educational and evaluation purposes only. Commercial use, distribution, and unauthorized modification of this software are strictly prohibited under the terms of the proprietary license. See the `LICENSE` file for full terms.

---

## About SidWinder

![show_case gif](assets/Show_case.gif)

SidWinder is an ultra-lightweight, source-available browser video grabber and download accelerator. It connects a local lightweight Google Chrome extension to a custom local `yt-dlp` and `FFmpeg` pipeline using Chrome's secure **Native Messaging API**. 

With a single click in your browser toolbar, it launches a detached high-speed download process, auto-resolves format merges, caps resolution at 1440p (to prevent system lag), and saves files directly to your default `Downloads` folder.

---

## Directory Structure

This project follows a clean "Separation of Concerns" design pattern, keeping your scripts, configurations, binaries, and browser assets isolated:

```text
└── SidWinder/
    ├── .gitignore
    ├── bridge.bat
    ├── CLA.md
    ├── com.foss.ytdlp.json
    ├── CONTRIBUTING.md
    ├── LICENSE
    ├── README.md
    ├── reg_installer.bat
    ├── reg_uninstaller.bat
    ├── setup_engines.bat
    ├── src/
    │   └── bridge.py
    ├── config/
    │   └── yt-dlp.conf
    ├── bin/
    │   ├── ffmpeg.exe
    │   ├── ffplay.exe
    │   ├── ffprobe.exe
    │   └── yt-dlp.exe
    ├── extension/
    │   └── ytdlp-extension/
    │       ├── background.js
    │       └── manifest.json
    └── .github/
        └── workflows/
            └── cla.yml
```

---

## Installation & Setup (For Any PC)

Follow these steps to set up the project on any Windows computer:

### Step 1: Download the Engines
1. Double-click **`setup_engines.bat`** in the root directory.
2. This script uses native Windows utilities to download and extract the latest compatible builds of `yt-dlp` and `FFmpeg` directly into your `bin/` folder.

### Step 2: Load the Chrome Extension
1. Open Google Chrome and navigate to `chrome://extensions/`.
2. Toggle **Developer mode** to **ON** in the top-right corner.
3. Click **Load unpacked** in the top-left corner.
4. Navigate to your project folder and select `extension/ytdlp-extension`.
5. Copy the long **ID** string displayed on your new extension card (e.g., `knldjmfmopnpolahpmmgbagdohdnhkik`).
6. Pin the extension icon to your browser toolbar.

### Step 3: Run the Installer
1. Double-click **`reg_installer.bat`** in the root directory.
2. When prompted, paste the **Extension ID** you copied in Step 2 and press Enter.
3. The installer will dynamically write your local host JSON manifest (`com.foss.ytdlp.json`) and register the secure bridge in your Windows user registry.


# How you use it?
1. Go to the *extensions* tab and then pin the extension for quick access.
2. Now, go to any youtube video, or probably almost any website out there that does not require cloudflare and click on the extension and it will start to download the video as per the config file settings.
3. If you have personal preferences such as download location or resolution or subtitles, then please, add them in config file using the internet. 
4. See below for more details!!

---

## How it Works Under the Hood

```
[ Toolbar Button ] ────► [ background.js ] ────► [ Chrome Native Messaging ]
                                                          │ (JSON payload)
                                                          ▼
[ bin/yt-dlp.exe ] ◄──── [ src/bridge.py ] ◄──── [ bridge.bat ] ◄─┘ (Standard Input)
```

1. **The Extension:** When clicked, `background.js` queries your active tab to capture the URL. It passes this URL as a structured JSON object to Chrome’s native messaging routing framework.
2. **The Registry Lookup:** Chrome inspects the Windows Registry at `HKCU\Software\Google\Chrome\NativeMessagingHosts\com.foss.ytdlp` to verify the sender and locate your local host JSON file (`com.foss.ytdlp.json`).
3. **The Script Bridge:** Chrome launches `bridge.bat` (which runs `src/bridge.py`) and pipes the JSON payload via standard input bytes (`stdin`).
4. **Subprocess Spawn:** `src/bridge.py` reads the payload, extracts the URL, resolves your folder path dynamically, and spawns a detached, visible CMD process executing the binary at `bin/yt-dlp.exe`.
5. **Config & Muxing:** `yt-dlp` loads your configurations from `config/yt-dlp.conf`, pulls the best streams, uses `bin/ffmpeg.exe` to stitch them together, and saves a smooth `.mp4` into your default `Downloads` folder.

---

## Customization

You can completely change how your downloader behaves by editing **`config/yt-dlp.conf`** in a text editor.

### Change the Save Directory:
By default, files are saved in your default Windows Downloads folder. You can change this to any absolute path (e.g., your Desktop or another drive):
```text
-P "C:\MyVideos"
```

### Auto-Organize by Website:
To automatically sort downloaded videos into separate folders named after the website they came from:
```text
-P "~/Downloads/%(extractor)s"
```

### Download Subtitles:
To automatically write and embed English subtitles into the downloaded video:
```text
--write-subs
--embed-subs
--sub-langs "en.*"
```

---

## Uninstallation / Cleanup
To completely remove this project from your computer:
1. Double-click **`reg_uninstaller.bat`** in the root directory. This deletes the registry keys and severs all connection bridges to the browser.
2. Open `chrome://extensions/` and click **Remove** on the SidWinder extension.
3. Delete this project folder. Your system is now 100% clean.


# ToDO
- advanced GUI.
- download path options.
- cloudflare bypass.
- support for more spicy sites out there.