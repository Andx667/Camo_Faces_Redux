#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 4: CONFIG
# --------------------------------
# Emits the CfgFaces classes and stringtable entries for the new heads, following the
# convention the hand-written face files already use: within a group only the first head
# inherits the vanilla head class, and every other class inherits that first CFR class. That
# is safe because a group's heads all share one `head` model, but it does mean any property
# the real head overrides has to be restated - see data/vanilla_props.json.
#
# Writes brand-new Faces_<Group>.hpp files outright, and appends to the existing ones. It is
# not idempotent against the existing files: re-running appends again, so revert them first
# (git checkout addons/faces) if you need to regenerate.

import json
import sys

from faces import NEW, GROUP_BASE, GROUP_FILE, SCHEME_NAMES, schemes_for
from paths import ADDON, DATA, TOOL_DATA

names = json.loads((TOOL_DATA / "names.json").read_text(encoding="utf-8"))
vprops = json.loads((TOOL_DATA / "vanilla_props.json").read_text(encoding="utf-8"))


def carried(cls, group):
    """Properties this head overrides relative to the class it will inherit."""
    ref = vprops.get(GROUP_BASE[group], {})
    return {k: v for k, v in vprops.get(cls, {}).items() if ref.get(k) != v}


def materials(f, scheme):
    """Material lines, when this head needs its own rvmat (see generate_materials.py)."""
    if not (DATA / scheme / f.code / f"{f.tex}.rvmat").exists():
        return []
    p = f"data\\{scheme}\\{f.code}"
    return [f"    material = QPATHTOF({p}\\{f.tex}.rvmat);",
            f"    materialWounded1 = QPATHTOF({p}\\{f.tex}_injury.rvmat);",
            f"    materialWounded2 = QPATHTOF({p}\\{f.tex}_injury.rvmat);"]


def main():
    by_group = {}
    for key, f in NEW.items():
        by_group.setdefault(f.group, []).append((key, f))

    strings = []
    for group, (fname, inherits) in GROUP_FILE.items():
        rows = by_group.get(group, [])
        if not rows:
            continue
        out, root = [], inherits

        for key, f in rows:
            schemes = schemes_for(key)
            first, rest = schemes[0], schemes[1:]
            me = f"GVAR({f.cls}_{SCHEME_NAMES[first][0]})"

            if root is None:                       # first head of a brand-new group
                out.append(f"class {f.cls};")
                parent = f.cls
            else:
                parent = root

            out.append(f"class {me}: {parent} {{")
            out.append("    author = AUTHOR;")
            out.append(f"    displayname = CSTRING({f.cls}_{SCHEME_NAMES[first][0]});")
            out.append(f"    texture = QPATHTOF(data\\{first}\\{f.code}\\{f.tex}_co.paa);")
            out.append("    identityTypes[] = {};")
            out += [f'    {k} = "{v}";' for k, v in carried(f.cls, group).items()]
            out += materials(f, first)
            out.append("    disabled = 0;")
            out.append("};")
            if root is None:
                root = me                          # later heads in the group hang off this one

            for scheme in rest:
                suffix = SCHEME_NAMES[scheme][0]
                out.append(f"class GVAR({f.cls}_{suffix}): {root} {{")
                out.append(f"    displayname = CSTRING({f.cls}_{suffix});")
                out.append(f"    texture = QPATHTOF(data\\{scheme}\\{f.code}\\{f.tex}_co.paa);")
                out += materials(f, scheme)
                out.append("};")
            out.append("")

            person = names[f.cls]
            for scheme in schemes:
                suffix, en, de = SCHEME_NAMES[scheme]
                strings.append((f"STR_CFR_Faces_{f.cls}_{suffix}",
                                f"{person['en']} {en}", f"{person['de']} {de}"))

        path = ADDON / fname
        body = "\n".join(out).rstrip() + "\n"
        if inherits is None:
            path.write_text(f"//{group} Heads\n{body}", encoding="utf-8")
        else:
            path.write_text(path.read_text(encoding="utf-8").rstrip()
                            + f"\n\n// {group} heads added by DLCs\n{body}", encoding="utf-8")
        print(f"{fname:22} {len(rows):2} heads")

    st = ADDON / "stringtable.xml"
    block = "".join(
        f'        <Key ID="{k}">\n            <English>{en}</English>\n'
        f'            <German>{de}</German>\n        </Key>\n' for k, en, de in strings)
    st.write_text(st.read_text(encoding="utf-8").replace("    </Package>", block + "    </Package>"),
                  encoding="utf-8")
    print(f"stringtable: +{len(strings)} keys (run `hemtt ln sort` afterwards)")


if __name__ == "__main__":
    sys.exit(main())
