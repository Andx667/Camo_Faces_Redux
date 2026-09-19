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

private _expiry = time + GVAR(wearOffTime) * 60;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_unit", "_face", "_expiry", "_camoId"];
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
    if (time >= _expiry) then {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        _unit setVariable [QGVAR(wearOffTimerId), -1];
        [_unit, _face] call FUNC(unsetCamo);
    };
}, 1, [_unit, _face, _expiry, _camoId]] call CBA_fnc_addPerFrameHandler;
_unit setVariable [QGVAR(wearOffTimerId), _pfhId];
