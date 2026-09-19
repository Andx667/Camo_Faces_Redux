#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether the given camo scheme can currently be applied through an ACE action - to the player
 * (self-action) or to another unit (buddy painting) - mirroring the combined preconditions of the
 * dialog flow (fnc_canShowAction + fnc_getCamoOptions + fnc_onLBCamoChanged's headgear/goggles/NV gate)
 * for a single scheme, without opening the dialog. The facepaint item is always the player's (the
 * painter's); the face and the headgear/goggles/NV that must be off are the target's. For someone
 * else's face the buddy-painting preconditions (fnc_canTargetBuddy) apply as well.
 *
 * Reads scheme data (face pairs, required item(s)) directly from cfr_common's GVAR(schemes) - the
 * single source of truth every scheme consumer reads from - rather than hardcoding a second copy of
 * the suffix/item mapping.
 *
 * Arguments:
 * 0: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
 * 1: Unit whose face is painted (default: ACE_player) <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * ["BWTarn"] call cfr_dialog_fnc_canApplyScheme
 *
 * Public: No
 */

params ["_camoSuffix", ["_target", ACE_player, [objNull]]];
TRACE_1("fnc_canApplyScheme",_this);

private _face = face _target;
private _result = false;

private _schemeIdx = EGVAR(common,schemes) findIf {(_x select 0) == _camoSuffix};
if (_schemeIdx != -1) then {
    (EGVAR(common,schemes) select _schemeIdx) params ["", "_pairs", "_itemClasses"];
    _result = (
        [ACE_player, _itemClasses] call EFUNC(common,hasFacepaint)
    ) && (
        (_pairs findIf {(_x select 0) == _face}) != -1
    ) && (
        headgear _target == "" && goggles _target == "" && hmd _target == ""
    ) && (
        _target == ACE_player || {[_target] call FUNC(canTargetBuddy)}
    );
};

_result;
