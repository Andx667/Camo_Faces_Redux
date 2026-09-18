#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 1: EXTRACT
# ---------------------------------
# Pulls from the game the vanilla textures the later stages need, and converts the mod's own
# shipped camo textures to PNG:
#
#   <work>/base_png/   vanilla head textures - the reference heads to fit on, and the new heads
#                      to paint onto
#   <work>/camo_png/   the camo textures the mod already ships, i.e. the fitting targets
#
# Reference heads are discovered from the mod's own data folders, so the fit automatically
# uses every hand-painted face currently in the repo.

import sys
from pathlib import Path

from faces import NEW, DLC_PBO, SCHEME_NAMES
from paths import DATA, WORK, arma3, run


def pull(pbo, inner, out_png, base_paa):
    """Extract one PAA from a PBO and convert it to PNG. Skips work already done."""
    if out_png.exists():
        return True
    if not base_paa.exists() and not run("utils", "pbo", "extract", str(pbo), inner, str(base_paa)):
        return False
    return run("utils", "paa", "convert", str(base_paa), str(out_png))


def main():
    a3 = arma3()
    base_png, camo_png, base_paa = WORK / "base_png", WORK / "camo_png", WORK / "base_paa"
    for d in (base_png, camo_png, base_paa):
        d.mkdir(parents=True, exist_ok=True)

    failed = []

    # Reference heads: whatever the mod already ships camo for. The folder name is the head
    # code and the single _co.paa inside names the vanilla texture.
    refs = 0
    for folder in sorted((DATA / "bwtarn").iterdir()):
        if not folder.is_dir():
            continue
        code = folder.name
        if code in {f.code for f in NEW.values()}:
            continue                                    # a head we are generating, not a reference
        tex = next((p.stem[:-3] for p in folder.glob("*_co.paa")), None)
        if tex is None:
            continue
        # White 16-21 come from the Episode B expansion PBO, everything else from the base game
        pbo = a3 / DLC_PBO["EPB" if code.startswith("WH") and code[2:].isdigit()
                           and 16 <= int(code[2:]) <= 21 else "Base"]
        if not pull(pbo, f"heads/data/{tex}_co.paa", base_png / f"{code}.png", base_paa / f"{tex}_co.paa"):
            failed.append(f"{code} ({tex})")
            continue
        refs += 1
        for scheme in SCHEME_NAMES:
            src = DATA / scheme / code / f"{tex}_co.paa"
            dst = camo_png / f"{code}_{scheme}.png"
            if src.exists() and not dst.exists():
                run("utils", "paa", "convert", str(src), str(dst))

    # The heads being generated
    for key, f in sorted(NEW.items()):
        if not pull(a3 / f.pbo, f"heads/data/{f.tex}_co.paa",
                    base_png / f"{key}.png", base_paa / f"{f.tex}_co.paa"):
            failed.append(f"{f.cls} ({f.tex})")

    print(f"reference heads: {refs}   targets: {len(NEW) - len([x for x in failed])}")
    print(f"base_png: {len(list(base_png.glob('*.png')))}   camo_png: {len(list(camo_png.glob('*.png')))}")
    if failed:
        print("\nFAILED to extract:")
        for f in failed:
            print(f"  {f}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
