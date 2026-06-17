import subprocess, os, re, shutil, glob, requests, zipfile

##################################################################################################################

PATH = os.path.dirname(__file__)

APKTOOL_PATH = PATH + "/libs/apktool.jar"

APK_NAME = "app-arizona-release_web"

DECODED_DIR = PATH + "/" + APK_NAME

APK_PATH = DECODED_DIR + ".apk"

##################################################################################################################

if not os.path.exists(APK_PATH):
    URL = "https://arz-mob.react-group.tech/game/release/launcher_new/app-arizona-release_web.apk"

    print(f"[INFO] 📥 Downloading latest original APK from {URL}...")

    with open(APK_PATH, 'wb') as f:
        f.write(requests.get(URL).content)

##################################################################################################################

if os.path.exists(DECODED_DIR):
    print("[INFO] 🗑️ Delete old decompiled app folder...")
    shutil.rmtree(DECODED_DIR, ignore_errors=True)

print("[INFO] ⚙️ Decompiling APK...")
subprocess.run(["java", "-jar", APKTOOL_PATH, "d", APK_PATH, "-o", DECODED_DIR, "--force"], check=True)
print("[INFO] ✅ APK decompiled successfully!")

##################################################################################################################

LIB_PATH = DECODED_DIR + "/lib/arm64-v8a"

print(f"[INFO] 🗑️ Delete arm64-v8a lib folder (Monetloader only x32)...")

if os.path.exists(LIB_PATH):
    shutil.rmtree(LIB_PATH)
    print("[INFO] ✅ Folder arm64-v8a removed successfully!")

##################################################################################################################

SRC_FILES = PATH + "/files"

print("[INFO] 🔧 Adding \"files\" to original client...")

for root, dirs, files in os.walk(SRC_FILES):
    for file in files:
        src_file = os.path.join(root, file)
        dest_file = os.path.join(DECODED_DIR, os.path.relpath(src_file, SRC_FILES))
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        shutil.copy2(src_file, dest_file)

print("[INFO] ✅ Folder \"files\" added successfully!")

##################################################################################################################

MONETLOADER_ZIP_PATH = "libs/monetloader.zip"
MONETLOADER_TARGET_DIR = os.path.join(DECODED_DIR, "assets", "monetloader")

print("[INFO] 🔧 Extracting MonetLoader core (libs & default scripts)...")
    
if not os.path.exists(MONETLOADER_ZIP_PATH):
    raise RuntimeError("❗ MonetLoader zip not found!")

try:
    with zipfile.ZipFile(MONETLOADER_ZIP_PATH, 'r') as zip_ref:
        zip_ref.extractall(MONETLOADER_TARGET_DIR)
    print("[INFO] ✅ MonetLoader core extracted successfully!")
except Exception as e:
    raise RuntimeError(f"❗ Failed to extract MonetLoader core: {e}")

##################################################################################################################

SMALI_CLASSES = glob.glob(DECODED_DIR + "/smali_classes*")

SMALI_PATH = ""

for smali_dir in SMALI_CLASSES:
    smali_dir = smali_dir.replace('\\', '/')
    potential_path = smali_dir + "/com/arizona/game/GTASAInternal.smali"
    if os.path.isfile(potential_path):
        SMALI_PATH = smali_dir.replace(DECODED_DIR, '')
        break

if SMALI_PATH == "":
    raise RuntimeError("❗ Failed to find GTASA smali folder!")

##################################################################################################################

GTASA_INTERNAL_PATH = DECODED_DIR + SMALI_PATH + "/com/arizona/game/GTASAInternal.smali"

print("[INFO] 🔗 Injecting MonetLoader into GTASAInternal.smali...")

with open(GTASA_INTERNAL_PATH, "r", encoding="utf-8") as file:
    smali_lines = file.readlines()

check_find_samp = False
check_connect = False

for i, line in enumerate(smali_lines):
    match1 = re.search(r'const-string(?:/jumbo)? (v\d+), "samp"', line)
    if match1:
        check_find_samp = True
        var_name = match1.group(1)

        if (f"invoke-static {{{var_name}}}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V" in smali_lines[i + 2] or f"invoke-static {{{var_name}}}, Lcom/arizona/game/GTASAInternal;->loadNativeLibrary(Ljava/lang/String;)V" in smali_lines[i + 2]):
            smali_lines.insert(i + 4, f'\n    const-string {var_name}, "monetloader"\n\n    invoke-static {{{var_name}}}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V\n\n')
            print("[INFO] ✅ MonetLoader injected successfully!")
            check_connect = True
            break

if not check_find_samp:
    raise RuntimeError("❌ Failed to locate 'samp' in GTASAInternal.smali.")

if not check_connect:
    raise RuntimeError("❌ Failed to locate 'samp' loadLibrary call in GTASAInternal.smali.")

with open(GTASA_INTERNAL_PATH, "w", encoding="utf-8") as file:
    file.writelines(smali_lines)

##################################################################################################################

print("[INFO] 🔄 Change package name to 'com.arizona.game' in all smali files...")

for filepath in glob.glob(DECODED_DIR + SMALI_PATH + "/**/*.smali", recursive=True):
    with open(filepath, "r", encoding="utf-8") as file:
        smali_data = file.read()

    smali_data = smali_data.replace("com.arizona21.game.web", "com.arizona.game")
    smali_data = smali_data.replace("com.arizona21.game", "com.arizona.game")

    with open(filepath, "w", encoding="utf-8") as file:
        file.write(smali_data)

##################################################################################################################

MANIFEST_PATH = DECODED_DIR + "/AndroidManifest.xml"

with open(MANIFEST_PATH, "r", encoding="utf-8") as file:
    manifest_data = file.read()

print("[INFO] 🔄 Change package name to 'com.arizona.game' in AndroidManifest...")
manifest_data = manifest_data.replace("com.arizona21.game.web", "com.arizona.game")
manifest_data = manifest_data.replace("com.arizona21.game", "com.arizona.game")

print("[INFO] 🏷  Change app name to 'Arizona Lua' in AndroidManifest...")
manifest_data = re.sub(r'android:label="@string/app_name"', 'android:label="Arizona Lua"', manifest_data)
if 'android:label="Arizona Lua"' in manifest_data:
    print("[INFO] ✅ App renamed successfully!")
else:
    raise RuntimeError("❌ Failed to update app label in AndroidManifest.xml.")

with open(MANIFEST_PATH, "w", encoding="utf-8") as file:
    file.write(manifest_data)

##################################################################################################################

smali_numbers = []

for path in SMALI_CLASSES:
    name = os.path.basename(path)
    if name.startswith("smali_classes"):
        num = name.replace("smali_classes", "")
        if num.isdigit():
            smali_numbers.append(int(num))

if not smali_numbers:
    raise RuntimeError("❌ No smali_classes folders found!")

LATEST_SMALI = max(smali_numbers)

##################################################################################################################

PATH_SMALI_TOOLS = DECODED_DIR + f"/smali_classes{LATEST_SMALI + 1}"

print("[INFO] 🔧 Compiling MTG Tools from java files to smali...")

def compile_java_to_smali():
    classpath = f"libs/android.jar{os.pathsep}libs/unity-ads.jar"

    java_dir = "java" 
    java_files = [
        os.path.join(java_dir, f) 
        for f in os.listdir(java_dir) 
        if f.endswith('.java') and "(NoAds version)" not in f
    ]
    
    if not java_files:
        raise RuntimeError(f"❗ Java source files not found in {java_dir} folder!")

    try:
        print("[INFO] ⚙️ Java -> Class...")
        subprocess.run([
            "javac", 
            "--release", "8", 
            "-Xlint:-options",
            "-nowarn",
            "-cp", classpath
        ] + java_files, check=True)

        print("[INFO] ⚙️ Class -> Dex...")
        class_files = [os.path.join(java_dir, f) for f in os.listdir(java_dir) if f.endswith('.class')]
        subprocess.run([
            "java", "-cp", "libs/d8.jar", "com.android.tools.r8.D8", 
            "--release", 
            "--output", ".", 
            "--lib", "libs/android.jar",
            "--lib", "libs/unity-ads.jar"
        ] + class_files, check=True)

        print("[INFO] ⚙️ Dex -> Smali...")
        subprocess.run([
            "java", "-jar", "libs/baksmali.jar", 
            "d", "classes.dex", 
            "-o", PATH_SMALI_TOOLS
        ], check=True)

        print("[INFO] ✅ MTG Tools compiled successfully!")

    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"❗ Failed compile MTG Tools: {e}")
    finally:
        if os.path.exists("classes.dex"):
            os.remove("classes.dex")
        
        for f in os.listdir(java_dir):
            if f.endswith('.class'):
                os.remove(os.path.join(java_dir, f))
                
compile_java_to_smali()

##################################################################################################################

PATH_SMALI_ADS = DECODED_DIR + f"/smali_classes{LATEST_SMALI + 2}"

print("[INFO] 🔧 Compiling Unity Ads from jar to smali...")

def compile_unity_ads_to_smali():
    unity_jar = "libs/unity-ads.jar"
    temp_dex_dir = "temp_unity_dex"

    if not os.path.exists(unity_jar):
        raise RuntimeError("❗ Unity Ads jar not found!")

    os.makedirs(temp_dex_dir, exist_ok=True)

    try:
        print("[INFO] ⚙️ Unity Ads Jar -> Dex...")
        subprocess.run([
            "java", "-cp", "libs/d8.jar", "com.android.tools.r8.D8",
            "--release",
            "--output", temp_dex_dir,
            "--lib", "libs/android.jar",
            unity_jar
        ], check=True)

        print("[INFO] ⚙️ Dex -> Smali...")

        dex_file = os.path.join(temp_dex_dir, "classes.dex")
        subprocess.run([
            "java", "-jar", "libs/baksmali.jar",
            "d", dex_file,
            "-o", PATH_SMALI_ADS
        ], check=True)

    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"❗ Failed compile Unity Ads: {e}")
    finally:
        if os.path.exists(temp_dex_dir):
            shutil.rmtree(temp_dex_dir)

    print("[INFO] ✅ Unity Ads compiled successfully!")

compile_unity_ads_to_smali()

##################################################################################################################

print("[INFO] 📢 Adding Unity Ads activities to AndroidManifest.xml...")

new_activities = '''
<activity android:configChanges="fontScale|keyboard|keyboardHidden|locale|mcc|mnc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|touchscreen|uiMode" android:hardwareAccelerated="true" android:name="com.unity3d.services.ads.adunit.AdUnitActivity" android:theme="@android:style/Theme.NoTitleBar.Fullscreen" />
<activity android:configChanges="fontScale|keyboard|keyboardHidden|locale|mcc|mnc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|touchscreen|uiMode" android:hardwareAccelerated="true" android:name="com.unity3d.services.ads.adunit.AdUnitTransparentActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" />
<activity android:configChanges="fontScale|keyboard|keyboardHidden|locale|mcc|mnc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|touchscreen|uiMode" android:hardwareAccelerated="false" android:name="com.unity3d.services.ads.adunit.AdUnitTransparentSoftwareActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" />
<activity android:configChanges="fontScale|keyboard|keyboardHidden|locale|mcc|mnc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|touchscreen|uiMode" android:hardwareAccelerated="false" android:name="com.unity3d.services.ads.adunit.AdUnitSoftwareActivity" android:theme="@android:style/Theme.NoTitleBar.Fullscreen" />
'''

manifest_data = re.sub(
    r'(<activity[^>]+PlayCoreDialogWrapperActivity[^>]+/>)',
    r'\1' + new_activities,
    manifest_data
)

if 'com.unity3d.services.ads.adunit' in manifest_data:
    print("[INFO] ✅ Unity Ads activities added successfully!")
else:
    raise RuntimeError("❌ Failed to add Unity Ads activities to AndroidManifest.xml.")

with open(MANIFEST_PATH, "w", encoding="utf-8") as file:
    file.write(manifest_data)

##################################################################################################################

ARZ_SMALI_PATH = ""

for smali_dir in SMALI_CLASSES:
    smali_dir = smali_dir.replace('\\', '/')
    potential_path = smali_dir + "/com/arizona/launcher/UpdateService.smali"
    if os.path.isfile(potential_path):
        ARZ_SMALI_PATH = smali_dir.replace(DECODED_DIR, '')
        break

if ARZ_SMALI_PATH == "":
    raise RuntimeError("❗ Arizona Launcher smali folder not found!")

##################################################################################################################

MAIN_ENTRENCH_PATH = DECODED_DIR + ARZ_SMALI_PATH + "/com/arizona/launcher/MainEntrench.smali"

print("[INFO] 🔧 Injecting call MTGTools...")

with open(MAIN_ENTRENCH_PATH, "r", encoding="utf-8") as file:
    smali_lines = file.readlines()

check_toast = False
check_version = False

start_idx = None
cond3_count = 0
end_idx = None

for i, line in enumerate(smali_lines):
    if start_idx is None:
        if re.search(r'sget-object (v\d+), Landroid/os/Build;->SUPPORTED_ABIS:\[Ljava/lang/String;', line):
            start_idx = i
    else:
        if re.search(r':cond_4', line):
            cond3_count += 1
            if cond3_count == 2:
                end_idx = i
                break

if start_idx is not None and end_idx is not None:
    smali_lines[start_idx] = '\n    const-string v0, ""\n\n'
    del smali_lines[start_idx+1:end_idx + 1]
    print("[INFO] ✅ ABI check removed from Toast.")
else:
    raise RuntimeError("❌ ABI not found!")

for i, line in enumerate(smali_lines):
    match_toast = re.search(r'invoke-virtual {(v\d+)}, Landroid/widget/Toast;->show\(\)V', line)
    if match_toast:
        var_name_3 = match_toast.group(1)
        smali_lines[i] = f'    invoke-virtual {{{var_name_3}}}, Landroid/widget/Toast;->show()V\n\n    invoke-static {{p0, p0}}, Lcom/arizona/launcher/MtgTools;->initialize(Landroid/app/Activity;Landroid/content/Context;)V\n'
        print("[INFO] ✅ MTGTools injected successfully.")
        check_toast = True
        break

if not check_toast:
    raise RuntimeError("❌ Failed to inject MTGTools.")

version_pattern = re.compile(r'const-string (v\d+), " v(.+) release(?:_web)?"')
version_app = ""

for i, line in enumerate(smali_lines):
    match_version = version_pattern.search(line)
    if match_version:
        var_name_4, version_found = match_version.groups()
        version_app = "v" + version_found
        smali_lines[i] = f'    const-string {var_name_4}, "[MTG MODS]\\n\u2139\ufe0f ARZ v{version_found} \u2139\ufe0f"\n'
        print(f"[INFO] ✅ Launch toast updated to ARZ v{version_found}.")
        check_version = True
        break

if not check_version:
    raise RuntimeError("❌ Version not found!")

with open(MAIN_ENTRENCH_PATH, "w", encoding="utf-8") as file:
    file.writelines(smali_lines)

##################################################################################################################

UPDATE_SERVICE_PATH = DECODED_DIR + ARZ_SMALI_PATH + "/com/arizona/launcher/UpdateService.smali"

print("[INFO] 🔒 Disable client updates...")

with open(UPDATE_SERVICE_PATH, "r", encoding="utf-8") as file:
    smali_lines = file.readlines()

matches = [i for i, line in enumerate(smali_lines) if "needUpdateMsg" in line]

if len(matches) < 3:
    raise RuntimeError("❌ Unexpected UpdateService structure (needUpdateMsg not found enough times).")

# add \"const/4 p1, 0x0\" after 3/4 "needUpdateMsg"
insert_index = matches[2]
smali_lines.insert(insert_index + 2, "    const/4 p1, 0x0\n")

with open(UPDATE_SERVICE_PATH, "w", encoding="utf-8") as file:
    file.writelines(smali_lines)

print("[INFO] ✅ Client updates disabled successfully!")

##################################################################################################################

print("[INFO] ⚙️ Rebuilding APK...")
subprocess.run(["java", "-jar", APKTOOL_PATH, "b", DECODED_DIR], check=True)
print("[INFO] ✅ APK rebuilt successfully!")

##################################################################################################################

SIGNED_APK = os.path.join(PATH, f"MonetLoader {version_app}.apk")

if os.path.exists(SIGNED_APK):
    print(f"[INFO] 🗑️ Delete old signed apk...")
    os.remove(SIGNED_APK)

##################################################################################################################

from dotenv import load_dotenv
load_dotenv(os.path.join(PATH, ".env"))

APKSIGNER_PATH = PATH + "/libs/apksigner.jar"
UNSIGNED_APK = DECODED_DIR + "/dist/" + APK_NAME + ".apk"

KEYSTORE_PATH = PATH + "/key.jks"
KEY_ALIAS = os.getenv("KEY_ALIAS")
KEY_PASS = os.getenv("KEY_PASS")
KEYSTORE_PASS = os.getenv("KEYSTORE_PASS") or KEY_PASS

print("[INFO] 🔐 Signing APK...")

if os.path.exists(KEYSTORE_PATH) and KEY_ALIAS and KEY_PASS:
    try:
        subprocess.run([
            "java",
            "--enable-native-access=ALL-UNNAMED",
            "-jar",
            APKSIGNER_PATH,
            "sign",
            "--ks", KEYSTORE_PATH,
            "--ks-key-alias", KEY_ALIAS,
            "--ks-pass", f"pass:{KEYSTORE_PASS}",
            "--key-pass", f"pass:{KEY_PASS}",
            "--out", SIGNED_APK,
            UNSIGNED_APK
        ], check=True)
        print(f"[INFO] ✅ Signed successfully!")
        print(f"[INFO] ℹ️ Your launcher {version_app}: {SIGNED_APK}")
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] {e}")
else:
    print(f"[INFO] ➡️ Signing skipped (no keystore or env vars found)")
    shutil.move(UNSIGNED_APK, SIGNED_APK)
    print(f"[INFO] ℹ️ Your no_signed launcher: {SIGNED_APK}")
    
##################################################################################################################

print("[INFO] ✅ Build process completed successfully!")

print("[INFO] 🗑️ Remove temporary build directory...")
shutil.rmtree(DECODED_DIR, ignore_errors=True)

print("[INFO] 🗑️ Remove original downloaded APK...")
os.remove(APK_PATH)
    
##################################################################################################################

