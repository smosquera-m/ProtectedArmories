#!/usr/bin/env python3
"""
Syntax & Static Analysis Tool for Project Zomboid Lua Mods
File: tools/check_syntax.py
"""

import os
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

# Workspace root
ROOT_DIR = Path(__file__).resolve().parent.parent
LUA_DIR = ROOT_DIR / "media" / "lua"

# Color definitions for terminal output
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
BOLD = "\033[1m"
RESET = "\033[0m"


def check_lua_file(file_path):
    """
    Performs static checks on a Lua file:
    - Balanced block keywords (function, if, for, while vs end)
    - Invalid ternary syntax (e.g., obj:func and ...)
    - Accented characters in string literals (warning)
    """
    errors = []
    warnings = []

    with open(file_path, "r", encoding="utf-8", errors="replace") as f:
        lines = f.readlines()

    block_depth = 0
    in_multiline_comment = False

    for line_num, line in enumerate(lines, 1):
        clean_line = line.strip()

        # Handle multiline comments --[[ ... ]]
        if "--[[" in clean_line:
            in_multiline_comment = True
        if "]]" in clean_line and in_multiline_comment:
            in_multiline_comment = False
            continue
        if in_multiline_comment or clean_line.startswith("--"):
            continue

        # Strip inline comments
        if "--" in clean_line:
            clean_line = clean_line.split("--")[0].strip()

        if not clean_line:
            continue

        # Check for invalid method ternary syntax: obj:method and ...
        if re.search(r"\b\w+:\w+\s+and\b", clean_line):
            errors.append(
                f"Line {line_num}: Invalid method ternary syntax (colon method reference before 'and'): '{clean_line}'"
            )

        # Check for non-ASCII / accented characters in strings
        accented = re.findall(r"[áéíóúÁÉÍÓÚñÑ]", clean_line)
        if accented:
            warnings.append(
                f"Line {line_num}: Accented characters found {set(accented)} - May render as broken characters in PZ font engine: '{clean_line}'"
            )

        # Count block openers and closers
        # Openers: function, if, for, while
        openers = len(re.findall(r"\b(function|if|for|while)\b", clean_line))
        closers = len(re.findall(r"\b(end)\b", clean_line))

        block_depth += openers - closers

    if block_depth != 0:
        errors.append(f"Unbalanced block structures ('end' count mismatch: net depth = {block_depth})")

    return errors, warnings


def run_syntax_checks():
    print(f"\n{BOLD}{CYAN}[SCAN] Running Lua Static Analysis & Syntax Verification...{RESET}")
    total_errors = 0
    total_warnings = 0

    lua_files = list(LUA_DIR.rglob("*.lua"))
    if not lua_files:
        print(f"{YELLOW}No Lua files found in {LUA_DIR}{RESET}")
        return 0

    for file_path in sorted(lua_files):
        rel_path = file_path.relative_to(ROOT_DIR)
        errors, warnings = check_lua_file(file_path)

        if not errors and not warnings:
            print(f"  {GREEN}[OK]{RESET} {rel_path}")
        else:
            print(f"  {BOLD}{rel_path}{RESET}")
            for err in errors:
                print(f"    {RED}[ERROR] {err}{RESET}")
                total_errors += 1
            for warn in warnings:
                print(f"    {YELLOW}[WARN] {warn}{RESET}")
                total_warnings += 1

    print("-" * 60)
    if total_errors > 0:
        print(f"{RED}{BOLD}FAILED:{RESET} Found {total_errors} error(s) and {total_warnings} warning(s).")
    else:
        print(f"{GREEN}{BOLD}PASSED:{RESET} Syntax verification clean ({total_warnings} warnings).")

    return total_errors


if __name__ == "__main__":
    sys.exit(run_syntax_checks())
