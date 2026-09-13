#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Runs one 2-second ACE progress bar for a single layer of the camo apply sequence, then either
 * recurses into the next layer or (after layer 3) actually applies the camo via cfr_common's
 * fnc_setCamo. Split out as its own function (rather than nested code blocks inside
 * fnc_applyCamoAction.sqf) so nothing needs to close over a private variable through an external
 * function-call boundary - every value crosses through ace_common_fnc_progressBar's own "_args"
 * parameter or a preprocessor macro instead, both of which are safe at any nesting depth.
 *
 * Unlike the dialog's equivalent (fnc_applyCamo.sqf), the scheme's preconditions are re-checked for
 * the whole duration of each bar via fnc_canApplyScheme, so moving, taking damage, or putting
 * headgear back on mid-sequence cancels it instead of silently continuing regardless.
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 * 1: Layer number, 1-3 <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["BWTarn", 1] call cfr_dialog_fnc_applyCamoLayer
 *
 * Public: No
 */

params ["_camo", "_layer"];
TRACE_1("fnc_applyCamoLayer",_this);

private _titleKey = switch (_layer) do {
    case 1: { LSTRING(applyingLayer1) };
    case 2: { LSTRING(applyingLayer2) };
    default { LSTRING(applyingLayer3) };
};

private _onFinish = if (_layer >= 3) then {
    {
        params ["_args"];
        _args params ["_camo"];
        [ACE_player, _camo] call EFUNC(common,setCamo);
    }
} else {
    {
        params ["_args"];
        _args params ["_camo", "_layer"];
        [_camo, _layer + 1] call FUNC(applyCamoLayer);
    }
};

[
    2,
    [_camo, _layer],
    _onFinish,
    { hint (localize ELSTRING(common,invalidFace)); },
    localize _titleKey,
    { params ["_args"]; _args call FUNC(canApplyScheme); }
] call ace_common_fnc_progressBar;
