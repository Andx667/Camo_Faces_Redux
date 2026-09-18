#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 3: MATERIALS
# -----------------------------------
# Writes each new head's .rvmat and _injury.rvmat.
#
# A head's vanilla rvmat is the starting point, so its own material values and map paths are
# preserved, and only the stage that hardcodes the head's _co texture is repointed at CFR's
# camo texture. Reading each rvmat rather than deriving paths matters: m_tanoan_01, for one,
# reuses m_african_03's normal and specular maps.
#
# A head whose vanilla rvmat has no _co stage at all takes its diffuse from the CfgFaces
# `texture` property instead, so it needs no rvmat and simply inherits the vanilla material -
# true of the African heads the mod already ships, and of TanoanHead_A3_01.

import re
import sys

from faces import NEW, schemes_for
from paths import ADDON, DATA, WORK, arma3, run

PREFIX = "z\\cfr\\addons\\faces"
CO = re.compile(r'"([^"]*?_co\.paa)"', re.I)


def vanilla(tex, pbo, suffix=""):
    """Extract and derapify one vanilla rvmat. None if the game has no such file."""
    name = f"{tex}{suffix}"
    van = WORK / "van_rvmat"
    van.mkdir(parents=True, exist_ok=True)
    txt, raw = van / f"{name}.txt", van / f"{name}.rvmat"
    if not txt.exists():
        if not raw.exists() and not run("utils", "pbo", "extract", str(pbo), f"heads/data/{name}.rvmat", str(raw)):
            return None
        run("utils", "config", "derapify", str(raw), str(txt))
    return txt.read_text(encoding="utf-8", errors="replace") if txt.exists() else None


def co_stages(text):
    return [h for h in CO.findall(text) if "env_co" not in h.lower()]


def main():
    a3 = arma3()
    written = inherited = 0
    for key, f in sorted(NEW.items()):
        base = vanilla(f.tex, a3 / f.pbo)
        if base is None:
            print(f"  {f.cls:22} NO VANILLA RVMAT - skipped")
            continue
        if not co_stages(base):
            inherited += 1
            continue                        # no _co stage: inherits the vanilla material
        injury = vanilla(f.tex, a3 / f.pbo, "_injury")

        for scheme in schemes_for(key):
            out = DATA / scheme / f.code
            out.mkdir(parents=True, exist_ok=True)
            ours = f"{PREFIX}\\data\\{scheme}\\{f.code}\\{f.tex}_co.paa"
            for text, path in ((base, out / f"{f.tex}.rvmat"), (injury, out / f"{f.tex}_injury.rvmat")):
                if text is None:
                    continue
                for hit in co_stages(text):
                    text = text.replace(f'"{hit}"', f'"{ours}"')
                path.write_text(text, encoding="utf-8")
                written += 1

    print(f"wrote {written} rvmat files; {inherited} heads inherit the vanilla material (no _co stage)")


if __name__ == "__main__":
    sys.exit(main())
