#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Builds GVAR(all_faces), GVAR(faces_african), and GVAR(schemes) - the single shared source of
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

// African heads have no "Black" (night) camo variant defined in cfr_faces
GVAR(faces_african) = ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03"];

// vanilla BI-authored camo faces (Marksmen DLC) - one real, pre-existing CfgFaces variant per base
// face, named completely differently from the base (CamoHead_<Race>_<NN>_F, not a suffix pattern),
// so unlike the schemes below this can't be derived by string concatenation and has to be an
// explicit pair table
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
    ["Black", ((GVAR(all_faces) - GVAR(faces_african)) apply {[_x, FACES_CLASS_PREFIX + _x + "_Black"]}), [QEGVAR(items,BW_Facepaint), QEGVAR(items,Serbian_Facepaint), QEGVAR(items,US_Facepaint)], "camo_black"],
    ["BWStripes", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_BWStripes"]}), [QEGVAR(items,BW_Facepaint)], "camo_bwstripes"],
    ["Serbian", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_Serbian"]}), [QEGVAR(items,Serbian_Facepaint)], "camo_serbian"],
    ["USStripes", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USStripes"]}), [QEGVAR(items,US_Facepaint)], "camo_usstripes"],
    ["USStains", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USStains"]}), [QEGVAR(items,US_Facepaint)], "camo_usstains"],
    ["USFlash", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_USFlash"]}), [QEGVAR(items,US_Facepaint)], "camo_usflash"],
    // PROTOTYPE: EyeBlack (football-style eye-black stripes) - lives outside the BW/Serbian/US
    // military schemes, so it has its own dedicated item rather than accepting any of the three
    // facepaint items. Rolled out to all base faces same as every other scheme above.
    ["EyeBlack", (GVAR(all_faces) apply {[_x, FACES_CLASS_PREFIX + _x + "_EyeBlack"]}), [QEGVAR(items,EyeBlack_Facepaint)], "camo_eyeblack"]
];

// Vanilla is appended only if the Marksmen DLC (Steam App ID 332350) is actually available - every
// consumer just reads GVAR(schemes), so if this row was never added, Vanilla is automatically and
// completely invisible everywhere (UI, ACE actions, apply/remove) with no special-casing needed
// anywhere else. The 7 core schemes above have no dependency on this check at all.
if (isDLCAvailable 332350) then {
    GVAR(schemes) pushBack [
        "Vanilla",
        GVAR(vanillaCamoFacePairs),
        [QEGVAR(items,BW_Facepaint), QEGVAR(items,Serbian_Facepaint), QEGVAR(items,US_Facepaint)],
        "camo_vanilla"
    ];
};
