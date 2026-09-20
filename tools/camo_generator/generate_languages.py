#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 6: LANGUAGES
# -----------------------------------
# Gives every face name in addons/faces/stringtable.xml a translation in each language Arma 3
# ships (i18n.LANG_TAGS). A face is "<surname> <scheme label>": the surname is what the game
# itself calls that head in the language (data/names_i18n.json, from resolve_vanilla.py) and the
# scheme label comes from i18n.py.
#
# English and German are left exactly as they are - generate_config.py writes those. Idempotent:
# any other language already on a key is dropped and rewritten, so this is safe to re-run after
# generate_config.py adds new heads.

import json
import re
import sys
from xml.sax.saxutils import escape

from faces import SCHEME_NAMES
from i18n import LANG_TAGS, scheme_label
from paths import ADDON, TOOL_DATA

SUFFIXES = sorted((suffix for suffix, _, _ in SCHEME_NAMES.values()), key=len, reverse=True)
KEY_RE = re.compile(r'(?P<indent> *)<Key ID="STR_CFR_Faces_(?P<id>\w+)">(?P<body>.*?)</Key>', re.S)
LANG_RE = re.compile(r"\s*<(English|German)>.*?</\1>", re.S)


def split(face_id):
    for suffix in SUFFIXES:
        if face_id.endswith("_" + suffix):
            return face_id[: -len(suffix) - 1], suffix
    raise ValueError(f"{face_id}: no known scheme suffix")


def main():
    names = json.loads((TOOL_DATA / "names_i18n.json").read_text(encoding="utf-8"))
    path = ADDON / "stringtable.xml"
    with open(path, encoding="utf-8", newline="") as f:
        text = f.read()
    eol = "\r\n" if "\r\n" in text else "\n"
    text = text.replace("\r\n", "\n")

    missing = set()

    def rebuild(m):
        cls, suffix = split(m["id"])
        if cls not in names:
            missing.add(cls)
            return m[0]
        kept = "".join(x.group(0) for x in LANG_RE.finditer(m["body"]))  # English + German, untouched
        others = "".join(
            f"\n{m['indent']}    <{tag}>{escape(names[cls][tag] + ' ' + scheme_label(suffix, tag))}</{tag}>" for tag in LANG_TAGS)
        return f'{m["indent"]}<Key ID="STR_CFR_Faces_{m["id"]}">{kept}{others}\n{m["indent"]}</Key>'

    out = KEY_RE.sub(rebuild, text)
    path.write_text(out.replace("\n", eol), encoding="utf-8", newline="")
    keys = len(KEY_RE.findall(out))
    print(f"{keys} face names x {len(LANG_TAGS)} languages")
    if missing:
        print("no names_i18n entry (run resolve_vanilla.py):", ", ".join(sorted(missing)))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
