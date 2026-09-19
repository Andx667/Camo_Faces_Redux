#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Wipes the camo off another unit's face: a short ACE progress bar, cancelled if the target stops being
 * valid or leaves reach (fnc_canCleanBuddy, re-checked every frame), then cfr_common's fnc_unsetCamo on
 * the target. Tells the cleaner, and the target too if they're a player. Needs no facepaint item.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject] call cfr_dialog_fnc_cleanBuddy
 *
 * Public: No
 */

params [["_target", objNull, [objNull]]];
TRACE_1("fnc_cleanBuddy",_this);

[
    2,
    [_target],
    {
        params ["_args"];
        _args params ["_target"];

        [_target, face _target] call EFUNC(common,unsetCamo);
        hint format [localize LSTRING(buddyCleanedOther), name _target];

        // fnc_unsetCamo only hints the machine's own player, so the target has to be told separately
        if (isPlayer _target) then {
            [QGVAR(notifyTarget), [LSTRING(buddyCleanedYou), name ACE_player], _target] call CBA_fnc_targetEvent;
        };
    },
    { hint (localize LSTRING(buddyInterrupted)); },
    localize LSTRING(cleaningFace),
    {
        params ["_args"];
        _args params ["_target"];
        [_target] call FUNC(canCleanBuddy)
    }
] call ace_common_fnc_progressBar;
