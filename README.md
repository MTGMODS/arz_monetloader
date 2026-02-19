# 🧩 About this project

An **external tool** that adds **Lua scripting support** to the **Arizona Mobile** client through the external **MonetLoader** library - a Lua script loader for **GTA: San Andreas 2.00**, available at [t.me/monetloader](https://t.me/monetloader).   

This launcher build also integrates the **MTG Tools** module.
It is responsible for:
- 🧩 Automatically unpacking MonetLoader resource files
- 🗒️ Automatically installing default lua scripts
- 🔄 Checking if your launcher version is up to date
- 💰 Controlling Unity Ads behavior *(to support the project)*  

> This is an **independent third-party project**, created solely to extend  
> **Lua compatibility for Arizona Mobile**, and is **not affiliated with or endorsed by**
> **Arizona Games**, **Rockstar Games**, or any of their partners.  
> All trademarks belong to their respective owners.

---

## ⚙️ Features

### 🧠 Main 
- 🧩 Adds support **Lua-script** to the game with **MonetLoader**
- 🧩 Integrates **MTG Tools** and **Unity Ads**  
- 📂 Includes default MonetLoader resource files  
- 📂 Includes default Lua scripts  

### ⚙️ MonetLoader Integration
- Provides Lua-based scripting support *(x32 only)*

### 🧰 MTG Tools
- Installs MonetLoader resource files (Lua libraries, helper scripts, and related assets)  
- Checks for updates of the MonetLoader-based client  
- Manages included MTG modules  

### 💰 Unity Ads
- Loads and displays ads using the Unity SDK  
- Ads appear **once at startup** and **do not interrupt gameplay**  
- They can be **disabled** inside the launcher *(for VIP users)*  

---

## 📂 Project Structure

```bash
├── build_launcher.py                   # Main build automation script
├── apktool.jar                         # Decompiler/Recompiler
├── apksigner.jar                       # APK signing tool
├── key.jks                             # Keystore (replace with your own)
├── files/assets/                       # MonetLoader resource files
├── files/lib/                          # MonetLoader & LuaJIT libraries
├── files/smali_classes_*               # Injected custom smali code
├── java_source/MtgTools.java           # Core MTG integration logic
├── java_source/AssetExtractor.java     # Extracts required resource files
├── java_source/CheckUpdate.java        # Update check manager
└── java_source/Ads.java                # Unity Ads integration
```

# 🚀 Usage
### 1️⃣ Requirements
- **Python 3.10+**
- **Java 8+**
- **Keystore for signing final APK** *(if not provided — unsigned apk will be saved)*
---
### 2️⃣ Build Process
1. **Clone** this repository to your local machine  
2. Set your keystore credentials using environment variables:
**Linux / macOS (bash):**
```bash
export KEY_ALIAS="your_alias"
export KEY_PASS="your_key_password"
export KEYSTORE_PASS="your_keystore_password" # optional if same as KEY_PASS
```
**Windows (PowerShell, temporary)**
```powershell
$env:KEY_ALIAS="your_alias"
$env:KEY_PASS="your_key_password"
$env:KEYSTORE_PASS="your_keystore_password"
```
3. Update profile.json for actual libsamp
- https://www.youtube.com/watch?v=u6gdRxX3lSc
4. Run the build script in terminal:
```bash
python build_launcher.py
```


### 🧪 Example build logs
```bash
[INFO] ✅ Successful connected MonetLoader!
[INFO] ✅ Successful connected MtgTools!
[INFO] ℹ️ Your launcher: MonetLoader v16.5.1.apk
```

---

# 📜 License
- This project is released under the MIT License.
- You are free to modify, distribute, and build upon it, provided proper attribution is given.
