#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether the given camo scheme can currently be applied to the player via an ACE self-action -
 * mirrors the combined preconditions of the dialog flow (fnc_canShowAction + fnc_getCamoOptions +
 * fnc_onLBCamoChanged's headgear/goggles/NV gate) for a single scheme, without opening the dialog.
 *
 * Reads scheme data (face pairs, required item(s)) directly from cfr_common's GVAR(schemes) - the
 * single source of truth every scheme consumer reads from - rather than hardcoding a second copy of
 * the suffix/item mapping.
 *
 * Arguments:
 * 0: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
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

private _face = face ACE_player;
private _result = false;

private _schemeIdx = EGVAR(common,schemes) findIf {(_x select 0) == _camoSuffix};
if (_schemeIdx != -1) then {
    (EGVAR(common,schemes) select _schemeIdx) params ["", "_pairs", "_itemClasses"];
    _result = (
        (_itemClasses findIf {_x in uniformItems ACE_player}) != -1
    ) && (
        (_pairs findIf {(_x select 0) == _face}) != -1
    ) && (
        headgear ACE_player == "" && goggles ACE_player == "" && hmd ACE_player == ""
    );
};

_result;
