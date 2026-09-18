#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 2: TEXTURES
# ----------------------------------
# Fits each scheme's paint layer on every reference head, composites it onto the new heads,
# and writes the result straight into addons/faces/data/<scheme>/<code>/ as DXT1 PAAs.
#
# Run validate.py first if you have changed the model - it reports how faithfully each scheme
# reconstructs the faces it was fitted on.
#
#   python generate_textures.py [scheme ...]      (default: every scheme)

import sys
from pathlib import Path

from faces import NEW, SCHEME_NAMES, schemes_for
from paintlayer import Fit, apply, load, save
from paths import DATA, WORK, run


def references(scheme):
    """Reference heads that have a shipped texture for this scheme."""
    out = []
    for p in sorted((WORK / "camo_png").glob(f"*_{scheme}.png")):
        code = p.stem[: -len(scheme) - 1]
        if (WORK / "base_png" / f"{code}.png").exists():
            out.append(code)
    return out


def main(argv):
    schemes = argv or list(SCHEME_NAMES)
    if not (WORK / "base_png").is_dir():
        sys.exit(f"No extracted textures in {WORK} - run extract.py first")

    png_dir = WORK / "out_png"
    for scheme in schemes:
        refs = references(scheme)
        if len(refs) < 3:
            print(f"{scheme:12} SKIPPED - only {len(refs)} reference faces")
            continue

        fit = Fit()
        for code in refs:
            fit.add(load(WORK / "base_png" / f"{code}.png"),
                    load(WORK / "camo_png" / f"{code}_{scheme}.png"))
        alpha, u = fit.solve()

        written = 0
        for key, f in NEW.items():
            if scheme not in schemes_for(key):
                continue
            tmp = png_dir / scheme / f.code
            tmp.mkdir(parents=True, exist_ok=True)
            png = tmp / f"{f.tex}_co.png"
            save(png, apply(load(WORK / "base_png" / f"{key}.png"), alpha, u))

            out = DATA / scheme / f.code
            out.mkdir(parents=True, exist_ok=True)
            if run("utils", "paa", "convert", str(png), str(out / f"{f.tex}_co.paa")):
                written += 1
        print(f"{scheme:12} fitted on {len(refs):2} heads, coverage {100 * (alpha > 0.02).mean():5.1f}%, "
              f"wrote {written:2} textures")


if __name__ == "__main__":
    main(sys.argv[1:])
