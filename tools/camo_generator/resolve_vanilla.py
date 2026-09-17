#!/usr/bin/env python3

# CAMO GENERATOR - VANILLA LOOKUPS
# --------------------------------
# Produces the two data files generate_config.py reads, both committed under data/ so the
# normal pipeline needs neither the game's language PBOs nor a config dump:
#
#   data/names.json          each head's in-game surname (EN/DE), so CFR's face names follow
#                            the mod's "Surname + Scheme" convention
#   data/vanilla_props.json  each head's effective hairline/scalp properties. A CFR camo class
#                            inherits its group's *first* face, so anything the real face
#                            overrides has to be restated or it is silently lost - without
#                            this, Old Man wears a bald Tanoan scalp instead of his grey hair.
#
# Only needed when adding heads. Requires CFR_CONFIG_DUMP (see paths.py).

import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from faces import NEW, GROUP_BASE
from paths import TOOL_DATA, WORK, arma3, config_dump, run

LANG_PBOS = [
    "Expansion/Addons/language_f_exp.pbo",
    "Expansion/Addons/language_f_oldman.pbo",
    "Expansion/Addons/languagemissions_f_oldman.pbo",
    "Enoch/Addons/language_f_enoch.pbo",
    "Orange/Addons/language_f_orange.pbo",
    "Orange/Addons/languagemissions_f_orange.pbo",
]
CARRY = ["head", "textureHL", "materialHL", "textureHL2", "materialHL2"]


def cfg_faces_block():
    text = config_dump().read_text(encoding="utf-8", errors="replace")
    start = text.index("class CfgFaces")
    return text[start:text.index("\nclass CfgMimics", start)]


def parse_classes(block):
    """class -> (parent, declared properties) for everything under CfgFaces."""
    out = {}
    for m in re.finditer(r"class (\w+)\s*:\s*(\w+)\s*\{(.*?)\n\t\t\};", block, re.S):
        cls, parent, body = m.groups()
        props = {p: v.group(1) for p in CARRY
                 if (v := re.search(rf'^\s*{p}\s*=\s*"([^"]*)"', body, re.M | re.I))}
        key = re.search(r'displayname\s*=\s*"\$?([^"]+)"', body, re.I)
        out[cls] = (parent, props, key.group(1) if key else None)
    return out


def resolve(classes, cls, index):
    """Walk the vanilla inheritance chain for an effective value."""
    seen, out = set(), {}
    while cls in classes and cls not in seen:
        seen.add(cls)
        parent, props, key = classes[cls]
        if index == "props":
            for k, v in props.items():
                out.setdefault(k, v)
        elif key:
            return key
        cls = parent
    return out if index == "props" else None


def load_strings():
    a3 = arma3()
    strings = {}
    for rel in LANG_PBOS:
        dest = WORK / "lang" / Path(rel).stem
        if not dest.exists():
            run("utils", "pbo", "unpack", str(a3 / rel), str(dest))
        for xml in dest.rglob("stringtable.xml"):
            try:
                root = ET.parse(xml).getroot()
            except ET.ParseError:
                continue
            for key in root.iter("Key"):
                kid = (key.get("ID") or "").lower()
                en = key.find("English")
                if en is None or not en.text:        # campaign tables use <Original>
                    en = key.find("Original")
                de = key.find("German")
                if kid and en is not None and en.text:
                    strings[kid] = (en.text.strip(),
                                    (de.text or en.text).strip() if de is not None else en.text.strip())
    return strings


def main():
    classes = parse_classes(cfg_faces_block())
    strings = load_strings()

    names, props, missing = {}, {}, []
    for key, f in NEW.items():
        props[f.cls] = resolve(classes, f.cls, "props")
        skey = resolve(classes, f.cls, "name")
        hit = strings.get((skey or "").lower())
        if hit:
            names[f.cls] = {"en": hit[0], "de": hit[1]}
        else:
            missing.append(f"{f.cls} ({skey or 'no displayName'})")
    for base in set(GROUP_BASE.values()):
        props.setdefault(base, resolve(classes, base, "props"))

    TOOL_DATA.mkdir(exist_ok=True)
    (TOOL_DATA / "names.json").write_text(json.dumps(names, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    (TOOL_DATA / "vanilla_props.json").write_text(json.dumps(props, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

    print(f"names: {len(names)}/{len(NEW)}   props: {len(props)}")
    if missing:
        print("\nUNRESOLVED NAMES (add them to data/names.json by hand):")
        for m in missing:
            print(f"  {m}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
