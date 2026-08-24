#!/usr/bin/env python3
"""
Automated Unit Test Runner for Protected Armories Mod
File: tools/run_tests.py
"""

import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

ROOT_DIR = Path(__file__).resolve().parent.parent
CONFIG_LUA = ROOT_DIR / "media" / "lua" / "shared" / "ProtectedArmories_Config.lua"

GREEN = "\033[92m"
RED = "\033[91m"
CYAN = "\033[96m"
BOLD = "\033[1m"
RESET = "\033[0m"


def parse_config_data():
    """
    Parses ProtectedRooms and WeaponSprites directly from ProtectedArmories_Config.lua
    """
    protected_rooms = {}
    weapon_sprites = set()

    with open(CONFIG_LUA, "r", encoding="utf-8") as f:
        content = f.read()

    # Extract ProtectedRooms entries
    rooms_match = re.search(r"ProtectedArmories\.ProtectedRooms\s*=\s*\{([^}]+)\}", content, re.DOTALL)
    if rooms_match:
        for line in rooms_match.group(1).splitlines():
            m = re.search(r'\["([^"]+)"\]\s*=\s*"([^"]+)"', line)
            if m:
                protected_rooms[m.group(1)] = m.group(2)

    # Extract WeaponSprites entries
    sprites_match = re.search(r"ProtectedArmories\.WeaponSprites\s*=\s*\{([^}]+)\}", content, re.DOTALL)
    if sprites_match:
        for line in sprites_match.group(1).splitlines():
            m = re.search(r'\["([^"]+)"\]\s*=\s*(?:"([^"]+)"|true)', line)
            if m:
                weapon_sprites.add(m.group(1))

    return protected_rooms, weapon_sprites


def run_tests():
    print(f"\n{BOLD}{CYAN}[TEST] Running Automated Unit Tests for Protected Armories...{RESET}")
    passed = 0
    failed = 0

    protected_rooms, weapon_sprites = parse_config_data()

    # TEST 1: Build 42 Room Coverage
    expected_rooms = [
        "policegunstorage",
        "policestorage",
        "policelocker",
        "policeswat",
        "gunstorestorage",
        "armystorage",
        "prisonstorage",
        "securitystorage",
    ]

    print(f"\n  {BOLD}[Test Suite 1: Build 42 Protected Rooms Check]{RESET}")
    for room in expected_rooms:
        if room in protected_rooms:
            print(f"    {GREEN}[PASS]:{RESET} Room '{room}' is protected (Category: {protected_rooms[room]})")
            passed += 1
        else:
            print(f"    {RED}[FAIL]:{RESET} Room '{room}' is MISSING from ProtectedRooms!")
            failed += 1

    # TEST 2: Weapon Sprite Coverage
    expected_sprites = [
        "furniture_storage_02_8",
        "furniture_storage_02_9",
        "furniture_storage_02_10",
        "furniture_storage_02_11",
        "furniture_storage_02_4",
        "furniture_storage_02_5",
        "furniture_storage_02_6",
        "furniture_storage_02_7",
    ]

    print(f"\n  {BOLD}[Test Suite 2: Armory Locker Sprite Coverage]{RESET}")
    for sprite in expected_sprites:
        if sprite in weapon_sprites:
            print(f"    {GREEN}[PASS]:{RESET} Sprite '{sprite}' is protected in WeaponSprites")
            passed += 1
        else:
            print(f"    {RED}[FAIL]:{RESET} Sprite '{sprite}' is MISSING from WeaponSprites!")
            failed += 1

    # TEST 3: Moveable & Disassembly Protection Hooks Check
    print(f"\n  {BOLD}[Test Suite 3: Moveable & Disassembly Protection Hooks Check]{RESET}")
    client_lua = ROOT_DIR / "media" / "lua" / "client" / "ProtectedArmories_Client.lua"
    with open(client_lua, "r", encoding="utf-8") as f:
        client_code = f.read()

    missing_hooks = []
    for hook in ["canPickUpMoveable", "canScrapObjectInternal", "canDisassemble", "inamovible e indestructible"]:
        if hook.lower() not in client_code.lower():
            missing_hooks.append(hook)

    if not missing_hooks:
        print(f"    {GREEN}[PASS]:{RESET} Moveable, Disassembly, and Context Menu protection hooks are intact.")
        passed += 1
    else:
        print(f"    {RED}[FAIL]:{RESET} Missing protection hooks: {missing_hooks}")
        failed += 1

    # TEST 4: ISDestroyStuffAction Patch Check
    print(f"\n  {BOLD}[Test Suite 4: Destruction Action Patching]{RESET}")
    if "ISDestroyStuffAction" in client_code and "PreventSledgehammer" in client_code:
        print(f"    {GREEN}[PASS]:{RESET} ISDestroyStuffAction is patched against sledgehammer destruction.")
        passed += 1
    else:
        print(f"    {RED}[FAIL]:{RESET} ISDestroyStuffAction patch is missing in client script!")
        failed += 1

    # TEST 5: Deprecated Loot Respawn Clean Verification
    print(f"\n  {BOLD}[Test Suite 5: Loot Respawn Deprecation Verification]{RESET}")
    server_lua = ROOT_DIR / "media" / "lua" / "server" / "ProtectedArmories_Server.lua"
    with open(server_lua, "r", encoding="utf-8") as f:
        server_code = f.read()

    respawn_terms = ["snapshotLoot", "respawnLootIfNeeded", "EveryHours.Add(onEveryHours)"]
    found_respawn_terms = [t for t in respawn_terms if t in server_code]

    if not found_respawn_terms:
        print(f"    {GREEN}[PASS]:{RESET} Loot Respawn code successfully deprecated and purged from server logic.")
        passed += 1
    else:
        print(f"    {RED}[FAIL]:{RESET} Deprecated Loot Respawn references still present: {found_respawn_terms}")
        failed += 1

    # TEST 6: World-Spawn Constraint & Configurable Options Check
    print(f"\n  {BOLD}[Test Suite 6: World-Spawn Constraint & Configurable Options Check]{RESET}")
    config_lua = ROOT_DIR / "media" / "lua" / "shared" / "ProtectedArmories_Config.lua"
    with open(config_lua, "r", encoding="utf-8") as f:
        config_code = f.read()

    config_keys = ["OnlyWorldSpawned", "isPlayerCreated", "ProtectGunLockers", "ProtectArmorLockers", "ProtectSecurity"]
    missing_config_keys = [k for k in config_keys if k not in config_code]

    if not missing_config_keys:
        print(f"    {GREEN}[PASS]:{RESET} World-spawn restriction and configurable options are fully implemented.")
        passed += 1
    else:
        print(f"    {RED}[FAIL]:{RESET} Missing configurable keys in config script: {missing_config_keys}")
        failed += 1

    # TEST 7: Building & Room Metadata Structures Check
    print(f"\n  {BOLD}[Test Suite 7: Building & Room Metadata Structures Check]{RESET}")
    meta_keys = ["DefaultProtectedList", "DefaultSpriteList", "getRoomEntry", "getSpriteEntry", "CustomRoomsList"]
    missing_meta_keys = [k for k in meta_keys if k not in config_code]

    if not missing_meta_keys:
        print(f"    {GREEN}[PASS]:{RESET} Building & Room metadata structures and helper functions are verified.")
        passed += 1
    else:
        print(f"    {RED}[FAIL]:{RESET} Missing metadata keys in config script: {missing_meta_keys}")
        failed += 1

    print("-" * 60)
    if failed == 0:
        print(f"{GREEN}{BOLD}ALL TESTS PASSED ({passed}/{passed}){RESET}")
    else:
        print(f"{RED}{BOLD}TEST SUITE FAILED ({passed} passed, {failed} failed){RESET}")

    return failed


if __name__ == "__main__":
    sys.exit(run_tests())


