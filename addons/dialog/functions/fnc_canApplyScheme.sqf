#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether the given camo scheme can currently be applied to the player via an ACE self-action -
 * mirrors the combined preconditions of the dialog flow (fnc_canShowAction + fnc_getCamoOptions +
 * fnc_onLBCamoChanged's headgear/goggles/NV gate) for a single scheme, without opening the dialog.
 *
 * Takes only the scheme suffix (not the face list/item classname directly) - ACE's self-action
 * interaction menu rejects multi-element array literals passed into a condition (logs "bad condition
 * return" for every action using one), so the face list and required item are looked up internally
 * instead of being passed in from CfgVehicles.hpp.
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * ["BWTarn"] call cfr_dialog_fnc_canApplyScheme
 *
 * Public: No
 */

params ["_camoSuffix"];
TRACE_1("fnc_canApplyScheme",_this);

// "cfr_faces_" hardcoded rather than using cfr_common's FACES_CLASS_PREFIX macro - that macro is
// only defined in addons/common/script_component.hpp, which this (dialog) component doesn't include,
// so it wasn't expanding here and reached runtime as an undefined bareword variable.
private _faceList = switch (_camoSuffix) do {
    case "BWTarn": { EGVAR(common,faces_bwtarn) };
    case "Black": { EGVAR(common,faces_black) };
    case "BWStripes": { EGVAR(common,faces_bwstripes) };
    case "Serbian": { EGVAR(common,faces_serbian) };
    case "USStripes": { EGVAR(common,faces_usstripes) };
    case "USStains": { EGVAR(common,faces_usstains) };
    case "USFlash": { EGVAR(common,faces_usflash) };
    default { [] };
};

private _itemClass = switch (_camoSuffix) do {
    case "BWTarn";
    case "Black";
    case "BWStripes": { QEGVAR(items,BW_Facepaint) };
    case "Serbian": { QEGVAR(items,Serbian_Facepaint) };
    default { QEGVAR(items,US_Facepaint) };
};

private _face = face ACE_player;

(
    _itemClass in uniformItems ACE_player
) && (
    _face in EGVAR(common,all_faces)
) && (
    ("cfr_faces_" + _face + "_" + _camoSuffix) in _faceList
) && (
    headgear ACE_player == "" && goggles ACE_player == "" && hmd ACE_player == ""
);
