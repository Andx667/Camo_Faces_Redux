#!/usr/bin/env python3

# CAMO GENERATOR - FACE TABLE
# ---------------------------
# Which heads the generator covers and how each one is named on disk.
#
# Folder codes follow the mod's existing shorthand (WH=White, AH=African, AsHA3=Asian,
# GkHA3=Greek, PHA3=Persian) and add TnHA3=Tanoan, LvH=Livonian, RuH=Russian. Texture
# basenames keep the vanilla filename, as the rest of the mod already does.
#
# To cover further heads, add them to NEW (and its DLC's App ID to APPID), then run the pipeline
# described in README.md - generate_registry.py registers them with cfr_common.

from collections import namedtuple

Face = namedtuple("Face", "cls code tex dlc group pbo")

# The PBO each DLC's head textures live in, relative to the Arma 3 install.
DLC_PBO = {
    "Expansion": "Expansion/Addons/characters_f_exp.pbo",
    "Oldman": "Expansion/Addons/characters_f_oldman.pbo",
    "Enoch": "Enoch/Addons/characters_f_enoch.pbo",
    "Orange": "Orange/Addons/characters_f_orange.pbo",
    "Tacops": "Tacops/Addons/characters_f_tacops.pbo",
    "Tank": "Tank/Addons/characters_f_tank.pbo",
    "Base": "Addons/characters_f.pbo",
    "EPB": "Addons/characters_f_epb.pbo",
}

# Steam App IDs, written as requiredDLC by generate_registry.py and enforced with isDLCAvailable
# by cfr_common's fnc_init.sqf. Old Man
# declares no App ID of its own and ships inside Apex's folder, so it rides Apex's gate.
APPID = {"Expansion": 395180, "Oldman": 395180, "Enoch": 1021790, "Orange": 571710,
         "Tacops": 744950, "Tank": 798390}

NEW = {}


def _add(key, cls, code, tex, dlc, group):
    NEW[key] = Face(cls, code, tex, dlc, group, DLC_PBO[dlc])


for i in range(1, 9):                                                       # Apex - Tanoan
    _add(f"TanoanHead_A3_{i}", f"TanoanHead_A3_{i:02d}", f"TnHA3{i:02d}", f"m_tanoan_{i:02d}", "Expansion", "Tanoan")
_add("TanoanHead_A3_09", "TanoanHead_A3_09", "TnHA309", "m_old_man", "Oldman", "Tanoan")

for i in range(4, 8):                                                       # Apex - Asian
    _add(f"AsianHead_A3_{i}", f"AsianHead_A3_{i:02d}", f"AsHA3{i:02d}", f"m_asian_{i:02d}", "Expansion", "Asian")

for i, n in enumerate(["capek", "dillon", "homewood", "kesson", "kingsly",
                       "kruglikov", "smolko", "stype", "rudwell"], start=24):    # Contact
    _add(f"WhiteHead_{i}", f"WhiteHead_{i}", f"WH{i}", f"m_{n}", "Enoch", "White")
for i in range(1, 11):
    _add(f"LivonianHead_{i}", f"LivonianHead_{i}", f"LvH{i:02d}", f"m_livonianHead_{i}", "Enoch", "Livonian")
for i in range(1, 6):
    _add(f"RussianHead_{i}", f"RussianHead_{i}", f"RuH{i:02d}", f"m_russianHead_{i}", "Enoch", "Russian")

for i in range(11, 15):                                                     # Laws of War
    _add(f"GreekHead_A3_{i}", f"GreekHead_A3_{i}", f"GkHA3{i}", f"m_greek_{i}", "Orange", "Greek")
_add("WhiteHead_23", "WhiteHead_23", "WH23", "m_white_22", "Orange", "White")

# Tac-Ops Mission Pack and Tanks - named campaign personas, but ordinary non-disabled CfgFaces
# heads underneath, reusing their DLC's own vanilla head model (AfricanHead_01/GreekHead_A3_01/
# WhiteHead_01) rather than adding a new one.
_add("Barklem", "Barklem", "Barklem", "m_Barklem", "Tacops", "African")
_add("Mavros", "Mavros", "Mavros", "m_Mavros", "Tacops", "Greek")
_add("Sturrock", "Sturrock", "Sturrock", "m_Sturrock", "Tacops", "White")
_add("Ioannou", "Ioannou", "Ioannou", "m_Ioannou", "Tank", "Greek")

# Named campaign personas are not DLC-gated: their faces are ordinary heads that any mission can put a
# unit in whoever owns the DLC, so camo for them has to be offered to everyone (see docs/components/faces.md).
# generate_registry.py leaves requiredDLC off these.
UNGATED = {"Barklem", "Mavros", "Sturrock", "Ioannou"}

# Black paint on skin this dark reads as almost nothing, which is why the mod ships no Black
# variant for AfricanHead_01-03 either. Barklem shares AfricanHead_01's skin tone.
NO_BLACK = {k for k in NEW if k.startswith("TanoanHead")} | {"Barklem"}

# The head each group's CFR classes ultimately inherit from. A CFR camo class hangs off its
# group's *first* face, so generate_config.py has to restate anything the real face overrides.
GROUP_BASE = {"Tanoan": "TanoanHead_A3_01", "Livonian": "LivonianHead_1", "Russian": "RussianHead_1",
              "White": "WhiteHead_01", "Asian": "AsianHead_A3_01", "Greek": "GreekHead_A3_01",
              "African": "AfricanHead_01"}

# group -> (hpp file, class the group's first CFR class inherits; None = a brand-new file
# whose first face inherits the vanilla head class directly)
GROUP_FILE = {
    "Tanoan":   ("Faces_Tanoan.hpp", None),
    "Livonian": ("Faces_Livonian.hpp", None),
    "Russian":  ("Faces_Russian.hpp", None),
    "White":    ("Faces_White.hpp", "GVAR(WhiteHead_01_BWTarn)"),
    "Asian":    ("Faces_Asian.hpp", "GVAR(AsianHead_A3_01_BWTarn)"),
    "Greek":    ("Faces_Greek.hpp", "GVAR(GreekHead_A3_01_BWTarn)"),
    "African":  ("Faces_African.hpp", "GVAR(AfricanHead_01_BWTarn)"),
}

# BWTarn first: it is the variant every other scheme's class inherits from.
ORDER = ["bwtarn", "bwstripes", "black", "serbian", "usstripes", "usstains", "usflash", "snowstripes"]

# scheme folder -> (CfgFaces suffix, english, german), matching the shipped stringtable
SCHEME_NAMES = {
    "bwtarn":      ("BWTarn", "BW Camouflage", "BW Tarn"),
    "bwstripes":   ("BWStripes", "BW Stripes", "BW Streifen"),
    "black":       ("Black", "Black", "Schwarz"),
    "serbian":     ("Serbian", "Serbian", "Serbisch"),
    "usstripes":   ("USStripes", "US Stripes", "US Streifen"),
    "usstains":    ("USStains", "US Stains", "US Flecken"),
    "usflash":     ("USFlash", "US Flash", "US Sprüh"),
    "snowstripes": ("SnowStripes", "Snow Stripes", "Schneestreifen"),
}


def schemes_for(key):
    """The schemes a given head gets, in class-declaration order."""
    return [s for s in ORDER if not (s == "black" and key in NO_BLACK)]
