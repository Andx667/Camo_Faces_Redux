#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Starts the wear-off timer for a unit's freshly applied camo, on the machine that owns the unit.
 * Raised through the cfr_common_startWearOff CBA targeted event by fnc_setCamo.sqf, which decides
 * whether a timer is wanted at all (setting enabled, unit is player-controlled).
 *
 * Uses a cancellable CBA_fnc_addPerFrameHandler (instead of CBA_fnc_waitAndExecute, which can't be
 * cancelled) so fnc_unsetCamo.sqf can kill this outright the moment camo comes off. A second timer
 * for the same unit can't get created on top of it: every scheme's pairs (see fnc_init.sqf) map from
 * the same shared set of base faces, never from another scheme's camo face, so fnc_setCamo can't
 * match a unit already wearing camo and exits early until fnc_unsetCamo.sqf restores a base face.
 * That cancellation only reaches a timer on the machine running fnc_unsetCamo though (camo can be
 * removed or reapplied from anywhere, e.g. a Zeus), so the timer also checks the unit's synced
 * GVAR(camoId) against the one it was started for, and stands down if they no longer match.
 *
 * WEAR_OFF_WARNING_SECONDS before it expires the player gets a "starting to fade" hint - the
 * duration is randomised, so otherwise nobody can tell when camo is about to go. Skipped when the
 * whole duration is no longer than the warning, where it would fire the moment camo is applied.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Camo face the unit was given <STRING>
 * 2: Id of this application of camo, see fnc_setCamo.sqf <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "camoface", "2_1234.5"] call cfr_common_fnc_startWearOff
 *
 * Public: No
 */

params ["_unit", "_face", "_camoId"];
TRACE_1("fnc_startWearOff",_this);

if (isNull _unit) exitWith {};

// so every player doesn't lose their camo at the same instant, the duration is rolled per application
// on a bell curve centered on the configured time: random [min, mid, max] is Gaussian, with min/max
// the wear-off time minus/plus WEAR_OFF_VARIATION_MINUTES. Rolled here on the unit's owner rather than
// by fnc_setCamo's caller, so each player's timer gets its own roll. The floor keeps the variation
// on a short wear-off time from reaching zero or below, which would remove camo the moment it's applied
private _minutes = GVAR(wearOffTime);
if (WEAR_OFF_VARIATION_MINUTES > 0) then {
    _minutes = (random [_minutes - WEAR_OFF_VARIATION_MINUTES, _minutes, _minutes + WEAR_OFF_VARIATION_MINUTES]) max 1;
};

private _expiry = time + _minutes * 60;
// -1 = no warning (duration too short for one, or already given); _args is the same array on every
// tick, so the handler can mark the warning as given by overwriting this slot
private _warnAt = if (_minutes * 60 > WEAR_OFF_WARNING_SECONDS) then {_expiry - WEAR_OFF_WARNING_SECONDS} else {-1};
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_unit", "_face", "_expiry", "_camoId", "_warnAt"];
    if (isNull _unit) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (_unit getVariable [QGVAR(camoId), ""] != _camoId) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        // only clear the id if it is still this timer's - a newer timer on this machine may have replaced it
        if (_unit getVariable [QGVAR(wearOffTimerId), -1] == _pfhId) then {
            _unit setVariable [QGVAR(wearOffTimerId), -1];
        };
    };
    if (_warnAt != -1 && {time >= _warnAt}) then {
        _args set [4, -1];
        // hint is feedback for the wearer only - same guard as fnc_setCamo.sqf's _hintOwner
        if (_unit == player) then { hint (localize LSTRING(camoFading)); };
    };
    if (time >= _expiry) then {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        _unit setVariable [QGVAR(wearOffTimerId), -1];
        [_unit, _face] call FUNC(unsetCamo);
    };
}, 1, [_unit, _face, _expiry, _camoId, _warnAt]] call CBA_fnc_addPerFrameHandler;
_unit setVariable [QGVAR(wearOffTimerId), _pfhId];
