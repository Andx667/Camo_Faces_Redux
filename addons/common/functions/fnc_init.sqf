#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Builds GVAR(all_faces), GVAR(faces_noBlack), and GVAR(schemes) - the single shared source of
 * truth every consumer (apply/remove, dialog UI, ACE self-actions, the ZEN compat layer) reads
 * camo scheme data from - deriving each scheme's base-face/camo-face pairs from GVAR(all_faces)
 * so they can't drift out of sync with it. Also appends the Vanilla scheme if the Marksmen DLC is
 * available, and reapplies every unit's/corpse's saved camo face on mission (re)start.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call cfr_common_fnc_init
 *
 * Public: No
 */

params [];
TRACE_1("fnc_init",_this);

GVAR(all_faces) = ["PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03",
            "AsianHead_A3_01","AsianHead_A3_02","AsianHead_A3_03",
            "AfricanHead_01","AfricanHead_02","AfricanHead_03",
            "GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09",
            "WhiteHead_01","WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15","WhiteHead_16","WhiteHead_17","WhiteHead_18","WhiteHead_19","WhiteHead_20","WhiteHead_21"];

// Faces added by DLCs released after the base game. Appended only when that DLC is actually
// available, through the same isDLCAvailable gate the Vanilla scheme uses below: a client
// without the DLC never gets those faces into GVAR(all_faces), so they vanish from every
// consumer at once (dialog, ACE self-actions, ZEN compat) with no DLC-specific logic anywhere
// else - exactly how the Vanilla row already behaves for players without Marksmen.
{
    _x params ["_appId", "_dlcFaces"];
    if (isDLCAvailable _appId) then {
        GVAR(all_faces) append _dlcFaces;
    };
} forEach [
    // Apex. TanoanHead_A3_09 is the Old Man scenario's head: Old Man declares no appId of its
    // own and its PBO ships inside Apex's folder, so it rides along with Apex's gate rather
    // than being left ungated.
    [395180, ["TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_03","TanoanHead_A3_04","TanoanHead_A3_05","TanoanHead_A3_06","TanoanHead_A3_07","TanoanHead_A3_08","TanoanHead_A3_09",
            "AsianHead_A3_04","AsianHead_A3_05","AsianHead_A3_06","AsianHead_A3_07"]],
    // Contact
    [1021790, ["WhiteHead_24","WhiteHead_25","WhiteHead_26","WhiteHead_27","WhiteHead_28","WhiteHead_29","WhiteHead_30","WhiteHead_31","WhiteHead_32",
            "LivonianHead_1","LivonianHead_2","LivonianHead_3","LivonianHead_4","LivonianHead_5","LivonianHead_6","LivonianHead_7","LivonianHead_8","LivonianHead_9","LivonianHead_10",
            "RussianHead_1","RussianHead_2","RussianHead_3","RussianHead_4","RussianHead_5"]],
    // Laws of War
    [571710, ["GreekHead_A3_11","GreekHead_A3_12","GreekHead_A3_13","GreekHead_A3_14","WhiteHead_23"]],
    // Tac-Ops Mission Pack. Barklem, Mavros and Sturrock are named campaign personas, but their
    // CfgFaces classes are ordinary, non-disabled heads like any other - a mission can put a unit
    // in one of these faces regardless of who owns the DLC, so they need camo too.
    [744950, ["Barklem","Mavros","Sturrock"]],
    // Tanks. Same reasoning as Tac-Ops above, for the one face it adds.
    [798390, ["Ioannou"]]
];

// Heads with no "Black" (night) camo variant in cfr_faces - black paint on skin this dark reads
// as almost nothing, so neither the African nor the Tanoan heads have one. Barklem shares
// AfricanHead_01's skin tone, so it joins them.
GVAR(faces_noBlack) = ["AfricanHead_01","AfricanHead_02","AfricanHead_03","Barklem",
            "TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_03","TanoanHead_A3_04","TanoanHead_A3_05","TanoanHead_A3_06","TanoanHead_A3_07","TanoanHead_A3_08","TanoanHead_A3_09"];

// vanilla BI-authored camo faces (Marksmen DLC) - one real, pre-existing CfgFaces variant per base
// face, named completely differently from the base (CamoHead_<Race>_<NN>_F, not a suffix pattern),
// so unlike the schemes below this can't be derived by string concatenation and has to be an
// explicit pair table.
// These are NOT the same thing as the arid/lush/semi-arid faces further down, even though both
// come from Marksmen: a CamoHead_* face keeps the plain face texture and gets its camo from a
// shared mask (m_camo_mc.paa) in the material's second stage, which is why one generic pattern
// covers all 39 faces and why its identityTypes span every environment. The arid/lush/semi-arid
// faces instead have camo baked into their own textures, one per environment, and exist for only
// three faces. Four distinct looks, not duplicates.
GVAR(vanillaCamoFacePairs) = [
    ["PersianHead_A3_01", "CamoHead_Persian_01_F"],
    ["PersianHead_A3_02", "CamoHead_Persian_02_F"],
    ["PersianHead_A3_03", "CamoHead_Persian_03_F"],
    ["AsianHead_A3_01", "CamoHead_Asian_01_F"],
    ["AsianHead_A3_02", "CamoHead_Asian_02_F"],
    ["AsianHead_A3_03", "CamoHead_Asian_03_F"],
    ["AfricanHead_01", "CamoHead_African_01_F"],
    ["AfricanHead_02", "CamoHead_African_02_F"],
    ["AfricanHead_03", "CamoHead_African_03_F"],
    ["GreekHead_A3_01", "CamoHead_Greek_01_F"],
    ["GreekHead_A3_02", "CamoHead_Greek_02_F"],
    ["GreekHead_A3_03", "CamoHead_Greek_03_F"],
    ["GreekHead_A3_04", "CamoHead_Greek_04_F"],
    ["GreekHead_A3_05", "CamoHead_Greek_05_F"],
    ["GreekHead_A3_06", "CamoHead_Greek_06_F"],
    ["GreekHead_A3_07", "CamoHead_Greek_07_F"],
    ["GreekHead_A3_08", "CamoHead_Greek_08_F"],
    ["GreekHead_A3_09", "CamoHead_Greek_09_F"],
    ["WhiteHead_01", "CamoHead_White_01_F"],
    ["WhiteHead_02", "CamoHead_White_02_F"],
    ["WhiteHead_03", "CamoHead_White_03_F"],
    ["WhiteHead_04", "CamoHead_White_04_F"],
    ["WhiteHead_05", "CamoHead_White_05_F"],
    ["WhiteHead_06", "CamoHead_White_06_F"],
    ["WhiteHead_07", "CamoHead_White_07_F"],
    ["WhiteHead_08", "CamoHead_White_08_F"],
    ["WhiteHead_09", "CamoHead_White_09_F"],
    ["WhiteHead_10", "CamoHead_White_10_F"],
    ["WhiteHead_11", "CamoHead_White_11_F"],
    ["WhiteHead_12", "CamoHead_White_12_F"],
    ["WhiteHead_13", "CamoHead_White_13_F"],
    ["WhiteHead_14", "CamoHead_White_14_F"],
    ["WhiteHead_15", "CamoHead_White_15_F"],
    ["WhiteHead_16", "CamoHead_White_16_F"],
    ["WhiteHead_17", "CamoHead_White_17_F"],
    ["WhiteHead_18", "CamoHead_White_18_F"],
    ["WhiteHead_19", "CamoHead_White_19_F"],
    ["WhiteHead_20", "CamoHead_White_20_F"],
    ["WhiteHead_21", "CamoHead_White_21_F"]
];

// GVAR(schemes): the single source of truth every consumer (apply/remove/UI/ACE actions) reads from.
// Each row is [schemeId, pairs, itemClasses, stringKey]:
//   - pairs: [[baseFace, camoFace], ...] - which base face becomes which camo face under this scheme
//   - itemClasses: array of facepaint item classnames that unlock this scheme (almost always one
//     entry, except Black and Vanilla, which accept any of the three - Black is a pure color-shift,
//     not tied to a specific pattern, so any facepaint item should unlock it)
//   - stringKey: this component's stringtable key suffix for the scheme's display name
// The 7 core schemes are always present. pairs are derived from GVAR(all_faces) the same way as
// before (just keeping the base face alongside the result instead of discarding it), so they can't
// drift out of sync with the base face list.
GVAR(schemes) = [
    ["BWTarn", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_BWTarn"]}), [QEGVAR(items,BW_Facepaint)], "camo_bwtarn"],
    ["Black", ((GVAR(all_faces) - GVAR(faces_noBlack)) apply {[_x, FACES_CLASS_PREFIX + _x + "_Black"]}), [QEGVAR(items,BW_Facepaint), QEGVAR(items,Serbian_Facepaint), QEGVAR(items,US_Facepaint)], "camo_black"],
    ["BWStripes", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_BWStripes"]}), [QEGVAR(items,BW_Facepaint)], "camo_bwstripes"],
    ["Serbian", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_Serbian"]}), [QEGVAR(items,Serbian_Facepaint)], "camo_serbian"],
    ["USStripes", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USStripes"]}), [QEGVAR(items,US_Facepaint)], "camo_usstripes"],
    ["USStains", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USStains"]}), [QEGVAR(items,US_Facepaint)], "camo_usstains"],
    ["USFlash", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USFlash"]}), [QEGVAR(items,US_Facepaint)], "camo_usflash"],
    // SnowStripes - green base w/ white diagonal stripes. Has its own dedicated item
    // (GVAR(SnowStripes_Facepaint)) so its notebook dialog can show the white-swatch "snow"
    // paint-box variant instead of the shared brown one (see fnc_onLBCountryChanged.sqf).
    ["SnowStripes", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_SnowStripes"]}), [QEGVAR(items,SnowStripes_Facepaint)], "camo_snowstripes"]
];

// Marksmen also ships three environment-specific camo faces, but only as variants of three
// particular base faces rather than one per face like the CamoHead_* set above. Each variant is
// its own scheme row because a scheme's pairs map a base face to exactly one camo face, so one
// base face can't offer three choices within a single row. Which base face each one is painted
// over was confirmed by comparing the textures outside the painted area.
GVAR(markCamoFaceSchemes) = [
    ["VanillaArid", [
        ["PersianHead_A3_01", "PersianHead_A3_04_a"],
        ["GreekHead_A3_02", "GreekHead_A3_10_a"],
        ["WhiteHead_11", "WhiteHead_22_a"]
    ], "camo_vanilla_arid"],
    ["VanillaLush", [
        ["PersianHead_A3_01", "PersianHead_A3_04_l"],
        ["GreekHead_A3_02", "GreekHead_A3_10_l"],
        ["WhiteHead_11", "WhiteHead_22_l"]
    ], "camo_vanilla_lush"],
    ["VanillaSemiArid", [
        ["PersianHead_A3_01", "PersianHead_A3_04_sa"],
        ["GreekHead_A3_02", "GreekHead_A3_10_sa"],
        ["WhiteHead_11", "WhiteHead_22_sa"]
    ], "camo_vanilla_semiarid"]
];

// The vanilla rows are appended only if the Marksmen DLC (Steam App ID 332350) is actually
// available - every consumer just reads GVAR(schemes), so if these rows were never added they are
// automatically and completely invisible everywhere (UI, ACE actions, apply/remove) with no
// special-casing needed anywhere else. The 8 core schemes above have no dependency on this check.
if (isDLCAvailable 332350) then {
    private _anyFacepaint = [QEGVAR(items,BW_Facepaint), QEGVAR(items,Serbian_Facepaint), QEGVAR(items,US_Facepaint)];
    GVAR(schemes) pushBack ["Vanilla", GVAR(vanillaCamoFacePairs), _anyFacepaint, "camo_vanilla"];
    {
        _x params ["_schemeId", "_pairs", "_stringKey"];
        GVAR(schemes) pushBack [_schemeId, _pairs, _anyFacepaint, _stringKey];
    } forEach GVAR(markCamoFaceSchemes);
};
