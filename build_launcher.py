import subprocess, os, re, shutil, glob, requests

##################################################################################################################

PATH = os.path.dirname(__file__).replace("\\", "/")

APKTOOL_PATH = PATH + "/apktool.jar"

APK_NAME = "app-arizona-release_web"

DECODED_DIR = PATH + "/" + APK_NAME

APK_PATH = DECODED_DIR + ".apk"

##################################################################################################################

if not os.path.exists(APK_PATH):
    print(f"[INFO] 🚫 {APK_NAME}.apk not found")

    URL = "https://arz-mob.react-group.tech/game/release/launcher_new/app-arizona-release_web.apk"

    print(f"[INFO] 📥 Downloading latest APK from {URL}...")

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

# MonetLoader only x32

LIB_PATH = DECODED_DIR + "/lib/arm64-v8a"

print(f"[INFO] 🗑️ Removing folder: {LIB_PATH}")

if os.path.exists(LIB_PATH):
    shutil.rmtree(LIB_PATH)
    print("[INFO] ✅ arm64-v8a folder removed successfully!")

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
    raise RuntimeError("❗ Don't find work smali folder!")

##################################################################################################################

SRC_FILES = PATH + "/files"

print("[INFO] 🔧 Adding MonetLoader files...")

for root, dirs, files in os.walk(SRC_FILES):
    for file in files:
        src_file = os.path.join(root, file)
        dest_file = os.path.join(DECODED_DIR, os.path.relpath(src_file, SRC_FILES))
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        shutil.copy2(src_file, dest_file)

print("[INFO] ✅ MonetLoader files added successfully!")

##################################################################################################################

print("[INFO] 🔧 Adding MTG files...")

PATH_SMALI_ONE = DECODED_DIR + '/smali_classes_ONE'
PATH_SMALI_TWO = DECODED_DIR + '/smali_classes_TWO'

LATERS_SMALI = int(SMALI_CLASSES[-1].replace("\\", "/").replace(DECODED_DIR, '').replace("/smali_classes", ""))
PATH_SMALI_ONE_WORK = PATH_SMALI_ONE.replace('_ONE', f"{LATERS_SMALI + 1}")
PATH_SMALI_TWO_WORK = PATH_SMALI_TWO.replace('_TWO', f"{LATERS_SMALI + 2}")

os.rename(PATH_SMALI_ONE, PATH_SMALI_ONE_WORK)
os.rename(PATH_SMALI_TWO, PATH_SMALI_TWO_WORK)

print("[INFO] ✅ MTG files added successfully!")

##################################################################################################################

GTASA_INTERNAL_PATH = DECODED_DIR + SMALI_PATH + "/com/arizona/game/GTASAInternal.smali"

print("[INFO] 🔗 Injecting MonetLoader into GTASAInternal.smali...")

with open(GTASA_INTERNAL_PATH, "r", encoding="utf-8") as file:
    smali_lines = file.readlines()

check_connect = False

for i, line in enumerate(smali_lines):
    match1 = re.search(r'const-string(?:/jumbo)? (v\d+), "samp"', line)
    if match1:
        var_name = match1.group(1)
        if f"invoke-static {{{var_name}}}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V" in smali_lines[i + 2]:
            smali_lines.insert(i + 4, f'\n    const-string {var_name}, "monetloader"\n\n    invoke-static {{{var_name}}}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V\n\n')
            print("[INFO] ✅ MonetLoader injected successfully!")
            check_connect = True
            break

if not check_connect:
    raise RuntimeError("❌ Failed to locate 'samp' loadLibrary call in GTASAInternal.smali.")

with open(GTASA_INTERNAL_PATH, "w", encoding="utf-8") as file:
    file.writelines(smali_lines)

##################################################################################################################

print("[INFO] 🔄 Updating package name to 'com.arizona.game' in smali files...")

for filepath in glob.glob(f"{SMALI_PATH}/**/*.smali", recursive=True):
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

print("[INFO] 🔄 Updating package name to 'com.arizona.game' in smali files...")
manifest_data = manifest_data.replace("com.arizona21.game.web", "com.arizona.game")
manifest_data = manifest_data.replace("com.arizona21.game", "com.arizona.game")

print("[INFO] 🏷 Setting app name to 'Arizona Lua'...")
manifest_data = re.sub(r'android:label="@string/app_name"', 'android:label="Arizona Lua"', manifest_data)
if 'android:label="Arizona Lua"' in manifest_data:
    print("[INFO] ✅ Successful renamed!")
else:
    raise RuntimeError("❌ Failed to update app label in AndroidManifest.xml.")

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

for smali_dir in SMALI_CLASSES:
    smali_dir = smali_dir.replace('\\', '/')
    potential_path = smali_dir + "/ru/mrlargha/commonui/elements/hud/presentation/Hud.smali"
    if os.path.isfile(potential_path):
        print("[INFO] 🖥 Updating HUD label to 'arizona-rp.com (lua)'...")

        with open(potential_path, "r", encoding="utf-8") as file:
            hud_data = file.read()

        hud_data = hud_data.replace("arizona-rp.com", "arizona-rp.com (lua)")

        if 'arizona-rp.com (lua)' in hud_data:
            print("[INFO] ✅ HUD label updated successfully!")
            with open(potential_path, "w", encoding="utf-8") as file:
                file.write(hud_data)
        else:
            print("[WARN] ❌ Hud text don't find!")
        break

##################################################################################################################

UPDATE_SERVICE_PATH = DECODED_DIR + SMALI_PATH + "/com/arizona/launcher/UpdateService.smali"

print("[INFO] 🔒 Disabling original client updates...")
with open(UPDATE_SERVICE_PATH, "r", encoding="utf-8") as file:
    smali_lines = file.readlines()

matches = [i for i, line in enumerate(smali_lines) if "needUpdateMsg" in line]

# add \"const/4 p1, 0x0\" after 3/4 "needUpdateMsg"
insert_index = matches[2]
smali_lines.insert(insert_index + 2, "    const/4 p1, 0x0\n")

with open(UPDATE_SERVICE_PATH, "w", encoding="utf-8") as file:
    file.writelines(smali_lines)

print("[INFO] ✅ Client updates disabled successfully!")

##################################################################################################################

MAIN_ENTRENCH_PATH = DECODED_DIR + SMALI_PATH + "/com/arizona/launcher/MainEntrench.smali"

print("[INFO] 🔧 Injecting MTGTools...")

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
        if re.search(r':cond_3', line):
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
        print("[INFO] ✅ MTGTools initialized successfully.")
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

print("[INFO] 🏗 Rebuilding APK...")
subprocess.run(["java", "-jar", APKTOOL_PATH, "b", DECODED_DIR], check=True)
print("[INFO] ✅ APK rebuilt successfully!")

##################################################################################################################

SIGNED_APK = os.path.join(PATH, f"MonetLoader {version_app}.apk")

if os.path.exists(SIGNED_APK):
    print(f"[INFO] 🗑️ Delete old signed apk...")
    os.remove(SIGNED_APK)

##################################################################################################################

APKSIGNER_PATH = PATH + "/apksigner.jar"
UNSIGNED_APK = DECODED_DIR + "/dist/" + APK_NAME + ".apk"

KEYSTORE_PATH = PATH + "/key.jks"
KEY_ALIAS = os.getenv("KEY_ALIAS")
KEY_PASS = os.getenv("KEY_PASS")
KEYSTORE_PASS = os.getenv("KEYSTORE_PASS") or KEY_PASS

print("[INFO] 🔐 Signing APK...")

if os.path.exists(KEYSTORE_PATH) and KEY_ALIAS and KEY_PASS and KEYSTORE_PASS:
    try:
        subprocess.run([
            "java", "-jar", APKSIGNER_PATH, "sign",
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

if os.path.exists(DECODED_DIR):
    print("[INFO] 🗑️ Removing temporary build directory...")
    shutil.rmtree(DECODED_DIR, ignore_errors=True)

if os.path.exists(APK_PATH):
    print("[INFO] 🗑️ Removing original downloaded APK...")

    os.remove(APK_PATH)
    
##################################################################################################################

