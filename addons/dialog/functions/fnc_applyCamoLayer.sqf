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
 * headgear back on mid-sequence cancels it instead of silently continuing regardless. When painting
 * someone else that also covers them leaving reach or ceasing to be a valid target.
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 * 1: Layer number, 1-3 <NUMBER>
 * 2: Unit whose face is painted (default: ACE_player) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["BWTarn", 1] call cfr_dialog_fnc_applyCamoLayer
 *
 * Public: No
 */

params ["_camo", "_layer", ["_target", ACE_player, [objNull]]];
TRACE_1("fnc_applyCamoLayer",_this);

private _titleKey = switch (_layer) do {
    case 1: { LSTRING(applyingLayer1) };
    case 2: { LSTRING(applyingLayer2) };
    default { LSTRING(applyingLayer3) };
};

private _onFinish = if (_layer >= 3) then {
    {
        params ["_args"];
        _args params ["_camo", "_layer", "_target"];
        [_target, _camo] call EFUNC(common,setCamo);

        // fnc_setCamo only hints the machine's own player, so when painting someone else the painter
        // and (if a player) the target have to be told separately
        if (_target != ACE_player) then {
            hint format [localize LSTRING(buddyPaintedOther), name _target];
            if (isPlayer _target) then {
                [QGVAR(notifyTarget), [LSTRING(buddyPaintedYou), name ACE_player], _target] call CBA_fnc_targetEvent;
            };
        };
    }
} else {
    {
        params ["_args"];
        _args params ["_camo", "_layer", "_target"];
        [_camo, _layer + 1, _target] call FUNC(applyCamoLayer);
    }
};

[
    2,
    [_camo, _layer, _target],
    _onFinish,
    {
        // cancelled: "can't camouflage this face" for one's own face, but for someone else's it most
        // likely means they walked off or put headgear back on
        params ["_args"];
        _args params ["", "", "_target"];
        hint (localize ([LSTRING(buddyInterrupted), ELSTRING(common,invalidFace)] select (_target == ACE_player)));
    },
    localize _titleKey,
    { params ["_args"]; [_args select 0, _args select 2] call FUNC(canApplyScheme); }
] call ace_common_fnc_progressBar;
