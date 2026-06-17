# 🧩 About this project

An **external tool** that adds **Lua scripting support** to the **Arizona Mobile** client through the external **MonetLoader** library (from https://github.com/xefinity/MonetLoaderOSS).  

This launcher build also integrates the **MTG Tools** module.
It is responsible for:
- 🧩 Automatically unpacking MonetLoader resource files
- 🗒️ Automatically installing default lua scripts
- 🔄 Checking if your launcher version is up to date
- 💰 Controlling Unity Ads behavior *(to support the project)*  

> ⚠️ This is an **independent third-party project**, created solely to extend **Lua compatibility for Arizona Mobile**
> It is **not affiliated with, endorsed by, or connected to Arizona Games, Rockstar Games, or their partners.**   
> All trademarks and copyrights belong to their respective owners.

---

## ⚙️ Features

### 🧩 Core Functionality
- 1️⃣ Adds **Lua scripting** support via **MonetLoader** (x32 only)
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
    ├── unity-ads.jar           # Unity Ads SDK for monetization this project
    └── monetloader.zip         # Vendor MonetLoader core (unpacked dynamically)
```

# 🚀 Usage
### 1️⃣ Requirements
- **Python 3.10+**
- **Java 8+**
- **Keystore for signing final APK** *(if not provided — unsigned apk will be saved)*
---
### 2️⃣ Build Process
1. **Clone** this repository to your local machine  
2. Set your keystore credentials in .env file in the root folder

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

# 📜 License
- This project is released under the MIT License.
- You are free to modify, distribute, and build upon it, provided proper attribution is given.
