#!/usr/bin/env python3

# CAMO GENERATOR - VALIDATION
# ---------------------------
# Three independent checks:
#
#   fit     Hold-one-out over every reference head: fit the paint layer on all the others,
#           rebuild this one, and compare against the texture the mod actually ships. This is
#           what says whether the model is sound. SnowStripes is the sharpest test - it is the
#           only scheme whose source has no DXT round-trip noise, so it should come back to a
#           fraction of a level. The rest sit at the compression noise floor, around 2-3.
#
#   wiring  Cross-checks the three things that must agree or the mod breaks in-game:
#           fnc_init.sqf's face lists <-> CfgFaces classes <-> texture files on disk.
#
#   names   Checks every camo face is named after the head it belongs to. Nothing in the build
#           catches this - five hand-written faces shipped under the wrong person's surname, so
#           players saw a camo variant named after someone else entirely.
#
#   python validate.py [fit|wiring|names]        (default: all)

import json
import re
import sys

import numpy as np

from faces import NEW, SCHEME_NAMES, schemes_for
from paintlayer import Fit, apply, load
from paths import ADDON, DATA, REPO, TOOL_DATA, WORK


def fit_check():
    print(f"{'scheme':12} {'heads':>5} {'mean|e|':>8} {'p99':>6}  worst head")
    worst_overall = 0.0
    for scheme in SCHEME_NAMES:
        heads = [p.stem[: -len(scheme) - 1] for p in sorted((WORK / "camo_png").glob(f"*_{scheme}.png"))]
        heads = [h for h in heads if (WORK / "base_png" / f"{h}.png").exists()]
        if len(heads) < 3:
            continue
        base = {h: load(WORK / "base_png" / f"{h}.png") for h in heads}
        camo = {h: load(WORK / "camo_png" / f"{h}_{scheme}.png") for h in heads}

        full = Fit()
        for h in heads:
            full.add(base[h], camo[h])

        errs, worst = [], (0.0, "")
        for h in heads:
            full.remove(base[h], camo[h])
            alpha, u = full.solve()
            full.add(base[h], camo[h])
            e = np.abs(apply(base[h], alpha, u) - camo[h])
            errs.append(e)
            if e.mean() > worst[0]:
                worst = (e.mean(), h)
        e = np.concatenate([x.ravel() for x in errs])
        worst_overall = max(worst_overall, e.mean())
        print(f"{scheme:12} {len(heads):5} {e.mean():8.2f} {np.percentile(e, 99):6.1f}  {worst[1]} ({worst[0]:.2f})")
    return 0 if worst_overall < 8 else 1


def wiring_check():
    init = (REPO / "addons/common/functions/fnc_init.sqf").read_text(encoding="utf-8")

    def arr(name):
        m = re.search(rf"GVAR\({name}\)\s*=\s*\[(.*?)\];", init, re.S)
        return re.findall(r'"([^"]+)"', m.group(1)) if m else []

    base, no_black = arr("all_faces"), arr("faces_noBlack")
    dlc = {a: re.findall(r'"([^"]+)"', b) for a, b in re.findall(r"\[(\d{6,7}),\s*\[(.*?)\]\]", init, re.S)}
    all_faces = base + [f for v in dlc.values() for f in v]

    defined = set()
    for h in ADDON.glob("Faces_*.hpp"):
        defined |= set(re.findall(r"class GVAR\((\w+)\)", h.read_text(encoding="utf-8")))

    problems, expected = [], 0
    for face in all_faces:
        for scheme, (suffix, _, _) in SCHEME_NAMES.items():
            if suffix == "Black" and face in no_black:
                continue
            expected += 1
            if f"{face}_{suffix}" not in defined:
                problems.append(f"MISSING CLASS   {face}_{suffix}")

    tex_re = re.compile(r"class GVAR\((\w+)\).*?texture = QPATHTOF\(data\\(\w+)\\(\w+)\\([\w.]+)\)", re.S)
    for h in ADDON.glob("Faces_*.hpp"):
        for cls, scheme, code, fname in tex_re.findall(h.read_text(encoding="utf-8")):
            if not (DATA / scheme / code / fname).exists():
                problems.append(f"MISSING TEXTURE {scheme}/{code}/{fname} (class {cls})")

    print(f"faces: {len(base)} base + {sum(len(v) for v in dlc.values())} dlc = {len(all_faces)}")
    for appid, v in sorted(dlc.items()):
        print(f"  appId {appid}: {len(v)}")
    print(f"classes expected {expected}, defined {len(defined)}; "
          f"textures on disk {len(list(DATA.rglob('*_co.paa')))}")
    for p in problems[:20]:
        print(" ", p)
    print("OK - face lists, config and textures agree" if not problems else f"{len(problems)} PROBLEMS")
    return 1 if problems else 0


def names_check():
    names = json.loads((TOOL_DATA / "names.json").read_text(encoding="utf-8"))
    st = (ADDON / "stringtable.xml").read_text(encoding="utf-8")

    suffix_en = {s: en for s, (_, en, _) in SCHEME_NAMES.items()}
    bad, checked = [], 0
    for cls, person in sorted(names.items()):
        for scheme, (suffix, _, _) in SCHEME_NAMES.items():
            m = re.search(rf'<Key ID="STR_CFR_Faces_{re.escape(cls)}_{suffix}">\s*<English>(.*?)</English>', st)
            if not m:
                continue
            checked += 1
            want = f"{person['en']} {suffix_en[scheme]}"
            if m.group(1) != want:
                bad.append((f"{cls}_{suffix}", want, m.group(1)))

    print(f"checked {checked} face names against the names the game gives those heads")
    for key, want, got in bad[:20]:
        print(f"  {key:34} expected {want!r}, found {got!r}")
    print("OK - every camo face is named after its own head" if not bad else f"{len(bad)} WRONG NAMES")
    return 1 if bad else 0


if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    rc, first = 0, True
    for name, fn in (("fit", fit_check), ("wiring", wiring_check), ("names", names_check)):
        if which in (name, "all"):
            if not first:
                print()
            rc |= fn()
            first = False
    sys.exit(rc)
