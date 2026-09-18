#!/usr/bin/env python3

# CAMO GENERATOR - STAGE 4: CONFIG
# --------------------------------
# Emits the CfgFaces classes and stringtable entries for the new heads, following the
# convention the hand-written face files already use: within a group only the first head
# inherits the vanilla head class, and every other class inherits that first CFR class. That
# is safe because a group's heads all share one `head` model, but it does mean any property
# the real head overrides has to be restated - see data/vanilla_props.json.
#
# Writes brand-new Faces_<Group>.hpp files outright, and appends to the existing ones. Safe to
# re-run after adding more heads to NEW: a head already present in a group's file (checked via
# its first class) or already in the stringtable (checked via its first key) is skipped, so
# re-running only emits whatever is actually new - no need to revert addons/faces first.

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
    """Material lines, when this head needs its own rvmat (see generate_materials.py). The
    injury rvmat is a separate check: a head can have its own base rvmat but no vanilla injury
    rvmat of its own (e.g. Mavros, Barklem, Sturrock), inheriting the wound material unchanged."""
    if not (DATA / scheme / f.code / f"{f.tex}.rvmat").exists():
        return []
    p = f"data\\{scheme}\\{f.code}"
    out = [f"    material = QPATHTOF({p}\\{f.tex}.rvmat);"]
    if (DATA / scheme / f.code / f"{f.tex}_injury.rvmat").exists():
        out += [f"    materialWounded1 = QPATHTOF({p}\\{f.tex}_injury.rvmat);",
                f"    materialWounded2 = QPATHTOF({p}\\{f.tex}_injury.rvmat);"]
    return out


def main():
    by_group = {}
    for key, f in NEW.items():
        by_group.setdefault(f.group, []).append((key, f))

    st_path = ADDON / "stringtable.xml"
    existing_st = st_path.read_text(encoding="utf-8")

    def already_in_stringtable(key, f):
        suffix = SCHEME_NAMES[schemes_for(key)[0]][0]
        return f'STR_CFR_Faces_{f.cls}_{suffix}"' in existing_st

    strings = []
    for group, (fname, inherits) in GROUP_FILE.items():
        rows = by_group.get(group, [])
        if not rows:
            continue

        path = ADDON / fname
        existing_hpp = path.read_text(encoding="utf-8") if inherits is not None and path.exists() else ""
        hpp_rows = rows if inherits is None else [
            (key, f) for key, f in rows
            if f"class GVAR({f.cls}_{SCHEME_NAMES[schemes_for(key)[0]][0]}):" not in existing_hpp]
        str_rows = [(key, f) for key, f in rows if not already_in_stringtable(key, f)]

        for key, f in str_rows:
            person = names[f.cls]
            for scheme in schemes_for(key):
                suffix, en, de = SCHEME_NAMES[scheme]
                strings.append((f"STR_CFR_Faces_{f.cls}_{suffix}",
                                f"{person['en']} {en}", f"{person['de']} {de}"))

        if inherits is not None and not hpp_rows:
            print(f"{fname:22}  0 heads (already up to date)")
            continue

        out, root = [], inherits

        for key, f in hpp_rows:
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
                # {root} is the GROUP's base class, not this head's own {me} - every scheme class
                # inherits from it directly (not from {me}), so anything carried() restated on
                # {me} has to be restated here too, or it is silently lost for every scheme but
                # the first. Without this, Old Man's grey hairline (carried on his own BWTarn
                # class above) would revert to TanoanHead_A3_01's bald scalp on every other scheme.
                out += [f'    {k} = "{v}";' for k, v in carried(f.cls, group).items()]
                out += materials(f, scheme)
                out.append("};")
            out.append("")

        body = "\n".join(out).rstrip() + "\n"
        if inherits is None:
            path.write_text(f"//{group} Heads\n{body}", encoding="utf-8")
        else:
            path.write_text(existing_hpp.rstrip() + f"\n\n// {group} heads added by DLCs\n{body}",
                            encoding="utf-8")
        print(f"{fname:22} {len(hpp_rows):2} heads")

    block = "".join(
        f'        <Key ID="{k}">\n            <English>{en}</English>\n'
        f'            <German>{de}</German>\n        </Key>\n' for k, en, de in strings)
    st_path.write_text(existing_st.replace("    </Package>", block + "    </Package>"), encoding="utf-8")
    print(f"stringtable: +{len(strings)} keys (run `hemtt ln sort` afterwards)")


if __name__ == "__main__":
    sys.exit(main())
