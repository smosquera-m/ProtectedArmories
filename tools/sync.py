#!/usr/bin/env python3
"""
Automated Build & Deployment Sync Tool
File: tools/sync.py
"""

import shutil
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

ROOT_DIR = Path(__file__).resolve().parent.parent
TARGET_MOD_DIR = Path(r"C:\Users\sergi\Zomboid\mods\ProtectedArmories")

GREEN = "\033[92m"
RED = "\033[91m"
CYAN = "\033[96m"
BOLD = "\033[1m"
RESET = "\033[0m"


def sync_build():
    print(f"\n{BOLD}{CYAN}[SYNC] Executing Mod Build & Deployment Sync...{RESET}")

    # 1. Sync workspace media into workspace 42/ subfolder
    workspace_42 = ROOT_DIR / "42"
    workspace_42_media = workspace_42 / "media"
    workspace_media = ROOT_DIR / "media"

    workspace_42.mkdir(parents=True, exist_ok=True)
    if workspace_42_media.exists():
        shutil.rmtree(workspace_42_media)
    shutil.copytree(workspace_media, workspace_42_media)

    # Copy root metadata files to 42/
    for fname in ["mod.info", "poster.png", "icon.png"]:
        src = ROOT_DIR / fname
        if src.exists():
            shutil.copy2(src, workspace_42 / fname)

    print(f"  {GREEN}[OK]{RESET} Workspace '42/' subfolder synchronized.")

    # 2. Deploy to user Zomboid mods directory
    TARGET_MOD_DIR.mkdir(parents=True, exist_ok=True)

    # Copy root workspace items to target mod folder (excluding .git, etc.)
    for item in ROOT_DIR.iterdir():
        if item.name.startswith(".") or item.name == "tools" or item.name == "dev.py":
            continue
        dest = TARGET_MOD_DIR / item.name
        if item.is_dir():
            if dest.exists():
                shutil.rmtree(dest)
            shutil.copytree(item, dest)
        else:
            shutil.copy2(item, dest)

    print(f"  {GREEN}[OK]{RESET} Mod successfully deployed to {TARGET_MOD_DIR}")
    print(f"\n{GREEN}{BOLD}BUILD & DEPLOYMENT COMPLETE!{RESET}\n")
    return 0


if __name__ == "__main__":
    sys.exit(sync_build())
