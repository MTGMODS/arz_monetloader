# 🧩 MTGMODS MonetLoader Builder [![Download Latest Release](https://img.shields.io/github/v/release/MTGMODS/arz_monetloader?label=Download%20Latest%20APK&style=for-the-badge&color=success)](https://github.com/MTGMODS/arz_monetloader/releases/latest)

<img width="900" height="400" alt="Logo" src="https://github.com/user-attachments/assets/8c570cb3-ed3f-4c39-8b14-9ecb3ab4ed83" />

An **external automation tool** (patcher) that adds **Lua scripting support** to the **[Arizona Mobile](https://arzgame.online/)** client through the external **[MonetLoader library](https://github.com/xefinity/MonetLoaderOSS)**.

This repository contains a build pipeline that dynamically patches the game. It is responsible for:
- 📥 Downloading the official client and decompiling it locally
- 🧩 Automatically unpacking MonetLoader resource files
- 🗒️ Automatically installing default Lua scripts & libs
- 🔄 Checking if the launcher version is up to date
- 💰 Managing Unity Ads behavior *(to support the continued development of this tool)*


> ⚠️ **LEGAL DISCLAIMER** > This repository **does not contain** any original game files, assets, or proprietary code belonging to Arizona Games. It is strictly a build automation tool (a patcher) that modifies the official client locally via CI/CD pipelines. The files provided in the Releases tab are automated build artifacts provided solely for educational purposes and user convenience.  
> This project is **independent and not affiliated with, endorsed by, or connected to Arizona Games, Rockstar Games, or their partners.** All trademarks and copyrights belong to their respective owners.

---

## ⚙️ Features

### 🧩 Core Functionality
- 1️⃣ Adds **Lua scripting** support via **MonetLoader** (32-bit only)
- 2️⃣ Integrates **MTG Tools** module and **Unity Ads** SDK

### ⚙️ MonetLoader Integration
- Provides Lua-based scripting support
- Includes required MonetLoader resource files
- Installs default Lua scripts and required libraries
- Provides an in-game `/mtg` command to install additional Lua scripts


### 🧰 MTG Tools
- Automatically extracts required Lua libraries and helper assets
- Manages bundled MTG modules
- Performs version checks for the modified launcher

### 💰 Unity Ads
- Loads and displays ads using the Unity SDK  
- Ads appear **once at startup** and **do not interrupt gameplay**  
- Can be **disabled** inside the launcher *(for MTGVIP subscribers)*  

---

## 📂 Project Structure

```bash
├── .env                        # Environment variables for keystore (optional)
├── key.jks                     # Keystore for signing the final APK (optional)
├── build_launcher.py           # Main build automation script (The Orchestrator)
├── files/                      # Payload directory (copied directly into the decompiled APK)
│   ├── assets/                 # Custom resources, Lua scripts & configs
│   └── lib/                    # Base MonetLoader native libraries (.so)
├── java/                       # Java source code for the wrapper
│   ├── Ads.java                # Unity Ads integration
│   ├── AssetExtractor.java     # Extracts required resource files
│   ├── CheckUpdate.java        # Update check manager
│   └── MtgTools.java           # Core MTG logic & Network checks
└── libs/                       # Build tools & heavy vendor archives
    ├── android.jar             # Android SDK for compiling Java code                  
    ├── apksigner.jar           # Signs the final rebuilt APK
    ├── apktool.jar             # Decompiles and recompiles the APK
    ├── baksmali.jar            # Disassembles .dex files into .smali format
    ├── d8.jar                  # Converts Java .class files to Android .dex
    ├── unity-ads.jar           # Unity Ads SDK (used for project monetization)
    └── monetloader.zip         # Vendor MonetLoader core (unpacked dynamically)
```

# 🚀 Usage
### 1️⃣ Requirements
- **Python 3.10+**
- **Java 8+**
- **Keystore for signing the final APK** *(if not provided — unsigned apk will be saved)*
---
### 2️⃣ Build Process

1. **Clone** this repository to your local machine  

2. Set your keystore credentials in the .env file located in the project root

```bash
KEY_ALIAS="alias"
KEY_PASS="key_password"
KEYSTORE_PASS="keystore_password" # optional if same as KEY_PASS
```

3. Update `profile.json` with the correct `libsamp` configuration  
(see tutorial: https://www.youtube.com/watch?v=u6gdRxX3lSc)

4. Run the build script in terminal:
```bash
python build_launcher.py
```

---

# 📜 License & Copyright

- **The code in this repository** (build scripts, Java wrappers, and custom Lua helpers) is released under the [MIT License](LICENSE). You are free to modify and distribute these specific tools.
- **MonetLoader** is an open-source project created by [xefinity](https://github.com/xefinity). Please refer to their repository for specific licensing terms.
- **Arizona Mobile** and all related trademarks, copyrights, and assets are the property of their respective owners. This project claims no ownership over the original game client. The final compiled APK generated by this tool is for personal use only.
