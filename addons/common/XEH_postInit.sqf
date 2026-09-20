#include "script_component.hpp"

[QGVAR(setFace), {
    params ["_unit", "_face"];
    _unit setFace _face;
}] call CBA_fnc_addEventHandler;

// targeted at the unit's owner by fnc_setCamo - see fnc_startWearOff.sqf
[QGVAR(startWearOff), {
    _this call FUNC(startWearOff);
}] call CBA_fnc_addEventHandler;

// Reapply each unit's saved face (e.g. after respawn/persistence) - needs units to actually exist,
// unlike GVAR(schemes) construction itself, which now happens in XEH_preInit (see fnc_init.sqf).
// A unit with an active camo scheme goes through fnc_setCamo itself rather than a bare setFace, so it
// gets treated exactly like a fresh manual application - including a new wear-off timer, since the one
// (if any) from before this unit's previous incarnation is gone with it. Only the locally-owning
// machine does this, so units with players on multiple clients don't each schedule their own timer.
{
    private _scheme = _x getVariable [QGVAR(scheme), ""];
    if (_scheme != "") then {
        if (local _x) then {
            [_x, _scheme] call FUNC(setCamo);
        };
    } else {
        private _face = _x getVariable [QGVAR(face), ""];
        if (_face != "") then {
            _x setFace _face;
        };
    };
} forEach (allUnits + allDead);

// Diving washes camo off (see fnc_handleAnimChanged.sqf). AnimChanged is only listened to on the local
// player's current unit - never every unit in the mission - so this costs one string check per player
// animation change and nothing while idle. The "unit" player event fires for the initial unit and again
// on respawn or a unit switch (e.g. Zeus), where the old unit's handler is dropped and the new one gets its own.
if (hasInterface) then {
    ["unit", {
        params ["_unit", "_oldUnit"];

        if (!isNull _oldUnit) then {
            _oldUnit removeEventHandler ["AnimChanged", _oldUnit getVariable [QGVAR(animChangedEH), -1]];
            _oldUnit setVariable [QGVAR(animChangedEH), nil];
        };

        if (!isNull _unit && {isNil {_unit getVariable QGVAR(animChangedEH)}}) then {
            _unit setVariable [QGVAR(animChangedEH), _unit addEventHandler ["AnimChanged", {call FUNC(handleAnimChanged)}]];
        };
    }, true] call CBA_fnc_addPlayerEventHandler;
};
