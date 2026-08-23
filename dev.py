#!/usr/bin/env python3
"""
Project Zomboid Mod Developer Toolkit CLI
File: dev.py

Usage:
  python dev.py lint   - Run static analysis & Lua syntax checks
  python dev.py test   - Run automated unit test suite
  python dev.py sync   - Run lint + test + deploy to Zomboid mods folder
  python dev.py watch  - File watcher: auto-check & auto-deploy on file save
  python dev.py all    - Run full lint, test, and sync pipeline
"""

import argparse
import sys
import time
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

ROOT_DIR = Path(__file__).resolve().parent

# Import tool modules
sys.path.insert(0, str(ROOT_DIR / "tools"))
import check_syntax
import run_tests
import sync

GREEN = "\033[92m"
RED = "\033[91m"
CYAN = "\033[96m"
BOLD = "\033[1m"
RESET = "\033[0m"


def run_all():
    print(f"\n{BOLD}{CYAN}===================================================={RESET}")
    print(f"{BOLD}{CYAN}  PROJECT ZOMBOID MOD TOOLKIT PIPELINE RUNNER     {RESET}")
    print(f"{BOLD}{CYAN}===================================================={RESET}")

    # 1. Lint & Syntax Check
    errors = check_syntax.run_syntax_checks()
    if errors > 0:
        print(f"\n{RED}{BOLD}Pipeline halted due to syntax errors.{RESET}")
        return 1

    # 2. Automated Tests
    failed_tests = run_tests.run_tests()
    if failed_tests > 0:
        print(f"\n{RED}{BOLD}Pipeline halted due to test failures.{RESET}")
        return 1

    # 3. Sync & Deploy
    sync.sync_build()
    return 0


def watch_mode():
    print(f"\n{BOLD}{CYAN}[WATCH] Starting Live File Watcher... (Press Ctrl+C to stop){RESET}")
    lua_dir = ROOT_DIR / "media" / "lua"

    def get_mtimes():
        mtimes = {}
        for p in lua_dir.rglob("*"):
            if p.is_file():
                mtimes[p] = p.stat().st_mtime
        return mtimes

    last_mtimes = get_mtimes()
    run_all()

    try:
        while True:
            time.sleep(1)
            current_mtimes = get_mtimes()
            if current_mtimes != last_mtimes:
                print(f"\n{BOLD}{CYAN}[EVENT] File change detected! Re-running pipeline...{RESET}")
                last_mtimes = current_mtimes
                run_all()
    except KeyboardInterrupt:
        print(f"\n{GREEN}Watcher stopped.{RESET}")


def main():
    parser = argparse.ArgumentParser(description="Project Zomboid Mod Developer Toolkit")
    parser.add_argument(
        "command",
        nargs="?",
        default="all",
        choices=["lint", "test", "sync", "watch", "all"],
        help="Command to run: lint | test | sync | watch | all",
    )

    args = parser.parse_args()

    if args.command == "lint":
        sys.exit(check_syntax.run_syntax_checks())
    elif args.command == "test":
        sys.exit(run_tests.run_tests())
    elif args.command == "sync":
        sys.exit(sync.sync_build())
    elif args.command == "watch":
        watch_mode()
    elif args.command == "all":
        sys.exit(run_all())


if __name__ == "__main__":
    main()
