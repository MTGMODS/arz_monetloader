import struct
import json
from elftools.elf.elffile import ELFFile
from capstone import Cs, CS_ARCH_ARM, CS_MODE_THUMB
from capstone.arm import ARM_OP_MEM, ARM_OP_REG, ARM_REG_R0

TARGET_CNETGAME = b"CNetGame: %s:%i - %s - [%s]"
TARGET_PACKETLOG = b"Can't add incomming data to packet_log"

text_data = b""
rodata_data = b""
TEXT_BASE = 0
RODATA_BASE = 0

def init_elf(libsamp_path):
    global text_data, rodata_data, TEXT_BASE, RODATA_BASE
    with open(libsamp_path, "rb") as f:
        elf = ELFFile(f)
        text = elf.get_section_by_name(".text")
        rodata = elf.get_section_by_name(".rodata")
        text_data = text.data()
        rodata_data = rodata.data()
        TEXT_BASE = text["sh_addr"]
        RODATA_BASE = rodata["sh_addr"]

def hex_pattern(data):
    return data.hex(" ").upper()

def read16(off):
    return struct.unpack_from("<H", text_data, off)[0]

def read32(off):
    return struct.unpack_from("<I", text_data, off)[0]

def pattern_to_bytes(pattern):
    result = []
    pattern = pattern.replace(" ", "")
    for i in range(0, len(pattern), 2):
        b = pattern[i:i+2]
        if b == "??":
            result.append(None)
        else:
            try:
                result.append(int(b, 16))
            except ValueError:
                print(f"[COMPAT] ⚠️ Invalid hex byte '{b}' found in pattern. Ignoring broken pattern.")
                return []
    return result

def find_pattern(data, pattern):
    if not pattern: return -1
    p = pattern_to_bytes(pattern)
    
    if not p or len(p) == 0: 
        return -1 
    
    for i in range(len(data) - len(p) + 1):
        ok = True
        for j, b in enumerate(p):
            if b is None: continue
            if data[i + j] != b:
                ok = False
                break
        if ok: return i
    return -1

def dump_signature(addr, size):
    off = addr - TEXT_BASE
    data = text_data[off:off+size]
    print(f"[COMPAT] Signature: {hex_pattern(data)}")
    return data

def find_string(target):
    idx = rodata_data.find(target)
    return RODATA_BASE + idx if idx != -1 else None

def find_string_xrefs(target_va):
    result = []
    for off in range(0, len(text_data)-16, 2):
        ins = read16(off)
        if (ins & 0xF800) != 0x4800:
            continue

        imm8 = ins & 0xFF
        ldr_addr = TEXT_BASE + off
        pc = (ldr_addr + 4) & ~3
        literal = pc + imm8 * 4
        literal_off = literal - TEXT_BASE

        if literal_off < 0 or literal_off + 4 > len(text_data):
            continue

        value = read32(literal_off)

        for lookahead in range(2, 20, 2):
            next_ins = read16(off + lookahead)
            if (next_ins & 0xFF00) == 0x4400:
                add_addr = ldr_addr + lookahead
                pc2 = add_addr + 4 
                resolved = (value + pc2) & 0xFFFFFFFF

                if resolved == target_va:
                    result.append({
                        "ldr_off": off,
                        "ldr_addr": ldr_addr,
                        "literal": literal,
                        "resolved": resolved
                    })
                    break
    return result

def find_function_start(xref_off):
    candidates = []
    i = xref_off
    while i >= 8:
        if text_data[i:i+2] == b"\xF0\xB5":
            ok = False
            for j in (4, 6, 8, 10, 12):
                if text_data[i+j:i+j+2] == b"\x2D\xE9":
                    ok = True
                    break
            if ok:
                candidates.append(i)
        i -= 2
    return TEXT_BASE + max(candidates) if candidates else None

def find_next_function(wrapper_addr):
    off = wrapper_addr - TEXT_BASE + 2
    while off < len(text_data) - 8:
        if text_data[off:off+2] == b"\xF0\xB5":
            return TEXT_BASE + off
        off += 2
    return None

def find_rakclient_offset(func_addr):
    if func_addr is None:
        return None
        
    off = func_addr - TEXT_BASE
    code = text_data[off:off + 0x200]

    md = Cs(CS_ARCH_ARM, CS_MODE_THUMB)
    md.detail = True

    this_reg = None
    offsets = []
    prev_was_call = False

    for insn in md.disasm(code, func_addr):
        if this_reg is None and insn.mnemonic == "mov":
            if len(insn.operands) == 2:
                op1, op2 = insn.operands
                if op2.type == ARM_OP_REG and op2.reg == ARM_REG_R0:
                    if op1.type == ARM_OP_REG:
                        this_reg = op1.reg

        if insn.mnemonic in ("bl", "blx"):
            prev_was_call = True
            continue
        
        if prev_was_call:
            if insn.mnemonic.startswith("str") and len(insn.operands) == 2:
                op1, op2 = insn.operands
                if op1.type == ARM_OP_REG and op1.reg == ARM_REG_R0:
                    if op2.type == ARM_OP_MEM and this_reg is not None and op2.mem.base == this_reg:
                        if op2.mem.disp >= 0x100:
                            offsets.append(op2.mem.disp)
            prev_was_call = False

    return max(offsets) if offsets else None

def generate_pattern(name, target, size=16):
    print(f"[COMPAT] Generating pattern for: {name}")
    va = find_string(target)
    
    if not va:
        print("[COMPAT] WARN: String not found!")
        return None, None

    xrefs = find_string_xrefs(va)
    if not xrefs:
        print("[COMPAT] WARN: XREFS not found!")
        return None, None

    for x in xrefs:
        func = find_function_start(x["ldr_off"])
        if target == TARGET_PACKETLOG and func:
            func = find_next_function(func)

        if func:
            pattern = dump_signature(func, size).hex().upper()
            return pattern, func
    
    return None, None

def load_profile(filename):
    with open(filename, encoding="utf8") as f:
        return json.load(f)

def save_profile(profile, filename):
    with open(filename, "w", encoding="utf8") as f:
        json.dump(profile, f, indent=4)
    print(f"[COMPAT] ✅ Saved updated profile to {filename}")

def update_compat(version_app, profile_path, libsamp_path):
    print(f"[INFO] 🔍 Checking MonetLoader profile compatibility for {version_app}...")
    
    init_elf(libsamp_path)
    
    profile = load_profile(profile_path)
    
    profile["profile_name"] = f"{version_app} by t.me/mtgmods"

    idx1 = find_pattern(text_data, profile.get("cnetgame_ctor_pattern", ""))
    idx2 = find_pattern(text_data, profile.get("receiveignorerpc_pattern", ""))

    ok1 = idx1 != -1
    ok2 = idx2 != -1

    if ok1 and ok2:
        func_addr = TEXT_BASE + idx1
        actual_offset = find_rakclient_offset(func_addr)
        json_offset = profile.get("rakclientinterface_netgame_offset")

        if actual_offset is not None:
            if actual_offset == json_offset:
                print("[COMPAT] ✅ Profile is up to date. Only version name updated.")
                save_profile(profile, profile_path)
                return
            else:
                print(f"[COMPAT] ⚠️ Offset changed ({json_offset} -> {actual_offset}). Updating...")
                profile["rakclientinterface_netgame_offset"] = actual_offset
                save_profile(profile, profile_path)
                return
        else:
            print("[COMPAT] ⚠️ Pattern found, but failed to extract offset. Forcing full generation.")
            ok1 = False

    print("[COMPAT] ⚠️ Patterns are outdated or not found. Generating new ones...")

    cnet_pattern, cnet_func = generate_pattern("CNETGAME", TARGET_CNETGAME)
    if cnet_pattern:
        profile["cnetgame_ctor_pattern"] = cnet_pattern
    
    if cnet_func:
        offset = find_rakclient_offset(cnet_func)
        if offset is not None:
            profile["rakclientinterface_netgame_offset"] = offset
            print(f"[COMPAT] ✅ Found RakClient offset: {offset} (0x{offset:X})")
        else:
            print("[COMPAT] ❌ CRITICAL: Failed to find RakClientInterface offset during generation!")

    rpc_pattern, _ = generate_pattern("receiveignorerpc", TARGET_PACKETLOG)
    if rpc_pattern:
        profile["receiveignorerpc_pattern"] = rpc_pattern

    save_profile(profile, profile_path)