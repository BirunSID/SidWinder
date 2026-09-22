# SidWinder

## ⚠️ License Notice
This project is **proprietary software**. The source code is publicly visible for educational and evaluation purposes only. Commercial use, distribution, and unauthorized modification of this software are strictly prohibited under the terms of the proprietary license. See the `LICENSE` file for full terms.

---

## About SidWinder

![show_case gif](assets/Show_case.gif)

SidWinder is an ultra-lightweight, source-available browser video grabber and download accelerator. It connects a local lightweight web extension to a custom local `yt-dlp` and `FFmpeg` pipeline using Chrome's secure **Native Messaging API**. 

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

### Step 2: Load the Extension
1. Open your browser and navigate to the Extensions page (e.g., `chrome://extensions/` or `brave://extensions/`).
2. Toggle **Developer mode** to **ON** in the top-right corner.
3. Click **Load unpacked** in the top-left corner.
4. Navigate to your project folder and select `extension/ytdlp-extension`.
5. Copy the long **ID** string displayed on your new extension card (e.g., `knldjmfmopnpolahpmmgbagdohdnhkik`).

### Step 3: Run the Installer
1. Double-click **`reg_installer.bat`** in the root directory.
2. When prompted, paste the **Extension ID** you copied in Step 2 and press Enter.
3. The installer will dynamically write your local host JSON manifest (`com.foss.ytdlp.json`) and register the secure bridge in your Windows user registry.

---

## How to Use It
1. Go to your browser's Extensions menu and **pin** the SidWinder extension for quick access.
2. Navigate to a video on YouTube or almost any streaming website, click the extension icon, and it will automatically launch a detached terminal window to download the video using your configuration settings.
3. To customize your default settings (such as save directories, speed limits, or automatic subtitle extraction), open `config/yt-dlp.conf` in any text editor.

---

## 🌐 Compatibility, Limitations & Gotchas

Before launching or contributing, please review these key limitations of the current architecture:

### 1. Browser Support (Chromium vs. Firefox)
* **Supported:** Out of the box, SidWinder supports all **Chromium-based browsers** (Google Chrome, Brave, Microsoft Edge, Opera, Opera GX, and Vivaldi). They all read from the same registry key and can share the same host file.
* **Not Supported (Yet):** **Mozilla Firefox** is not supported in the current release. Firefox uses a different rendering engine (Gecko) which requires a separate registry path and a modified JSON structure (`allowed_extensions` instead of `allowed_origins`) [1.1.3].

### 2. Website Restrictions (Cloudflare & DRM)
Because SidWinder uses `yt-dlp` under the hood, it is subject to the same web scraping restrictions [1.1.3]:
* **Cloudflare:** Websites heavily protected by Cloudflare DDoS verification walls or custom cookie challenges may block extraction, causing the CLI window to report network errors.
* **DRM (Digital Rights Management):** Premium streaming platforms (like Netflix, Prime Video, or Disney+) protect their streams with encrypted DRM. SidWinder cannot extract or download encrypted DRM content.

### 3. External Contributors & The CLA Bot (For Pull Requests)
If you decide to open a Pull Request to contribute to this repository:
* The repository is protected by a **Contributor License Agreement (CLA) Assistant** [1.1.3].
* Your Pull Request checks will initially fail on purpose [11.3]. You must read the `CLA.md` document and reply to the automated bot's comment with the exact signature phrase [11.3].
* Once signed, the check will turn green, your signature is cryptographically saved to our ledger, and the repository owner can merge your code [11.3].

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
2. Open your browser's extension page and click **Remove** on the SidWinder extension.
3. Delete this project folder. Your system is now 100% clean.

---

## ToDO (Roadmap)
- [ ] Add an advanced graphical user interface (GUI) wrapper for easier management.
- [ ] Implement the interactive path-picker (Downloads, Desktop, Permanent, and Temporary options).
- [ ] Develop native integration and support for Mozilla Firefox (Gecko engine compatibility) [1.1.3].
- [ ] Research automated cookies/headers passing to resolve basic Cloudflare and user verification blocks.
- [ ] Expand and maintain support for extraction scripts on obscure and specialized streaming sites.

---

- [ ] path issue, users have to manually set path to the bin folders and so this is complex and could introduce conflict with other yt-dlp paths or ffmpeg paths and this is dangerous. we have to introduce dynamic path allocation and override and also make it so that it can delete that created path to wipe this out.
- [ ] cmd closure, the cmd should close and then clear the terminal and display a "done message" with the necessary video details and sizes and resolutions that it grabbed and downloaded. 
- [ ] cmd should have cancel option in it. like . press ctrl C to cancel and keep the half done file and press ctrl shift C to cancel and delete the file.
- [ ] multiple browser (for now, chromium only) support that would auto add another browser by triggering or simplify the entire process. like, the setup to download bin and the bat file to Write registry entry pointing has to be the same and there should be a way to just add in the extension and have the ID auto added with no extra work on that part.
- [ ] the uninstaller should prompt the user that it will begin to uninstall everything and give 2 options. proceed with complete uninstallation to get rid of the registry stuffs first and then all the files in that folder.

---

- [ ] security ---> [hidden](readmeTODO.md)
- [ ] 