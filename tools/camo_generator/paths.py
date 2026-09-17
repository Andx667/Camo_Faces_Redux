#!/usr/bin/env python3

# CAMO GENERATOR - SHARED PATHS
# -----------------------------
# Locations every stage of the pipeline needs. Override any of them with an environment
# variable rather than editing this file:
#   CFR_ARMA3        Arma 3 install directory (otherwise found via Steam's libraryfolders.vdf)
#   CFR_WORK         scratch directory for extracted/intermediate files (default <repo>/.camo_work)
#   CFR_CONFIG_DUMP  a derapified dump of the game config, needed only by resolve_vanilla.py

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
ADDON = REPO / "addons" / "faces"
DATA = ADDON / "data"
TOOL_DATA = Path(__file__).resolve().parent / "data"
WORK = Path(os.environ.get("CFR_WORK") or REPO / ".camo_work")

STEAM_LIBRARY_HINTS = [
    r"C:\Program Files (x86)\Steam",
    r"C:\Program Files\Steam",
]


def arma3() -> Path:
    """Arma 3's install directory."""
    env = os.environ.get("CFR_ARMA3")
    if env:
        p = Path(env)
        if (p / "Addons").is_dir():
            return p
        sys.exit(f"CFR_ARMA3 is set to {p}, which does not look like an Arma 3 install")

    roots = []
    for hint in STEAM_LIBRARY_HINTS:
        vdf = Path(hint) / "steamapps" / "libraryfolders.vdf"
        if vdf.is_file():
            roots.append(Path(hint))
            roots += [Path(m) for m in re.findall(r'"path"\s+"([^"]+)"', vdf.read_text(errors="replace"))]
    for root in roots:
        p = root / "steamapps" / "common" / "Arma 3"
        if (p / "Addons").is_dir():
            return p
    sys.exit("Could not find Arma 3 - set CFR_ARMA3 to its install directory")


def hemtt() -> str:
    """HEMTT, which the pipeline shells out to for PBO and PAA work."""
    exe = shutil.which("hemtt") or shutil.which("hemtt.exe")
    if not exe:
        sys.exit("hemtt not found on PATH - see https://hemtt.dev")
    return exe


def run(*args) -> bool:
    """Run a hemtt subcommand, returning whether it succeeded."""
    return subprocess.run([hemtt(), *args], capture_output=True, text=True).returncode == 0


def config_dump() -> Path:
    p = os.environ.get("CFR_CONFIG_DUMP")
    if not p or not Path(p).is_file():
        sys.exit("Set CFR_CONFIG_DUMP to a derapified dump of the game config "
                 "(only resolve_vanilla.py needs it; its output is committed under data/)")
    return Path(p)
