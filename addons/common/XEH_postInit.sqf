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

// Swimming or diving washes camo off (see fnc_washOff.sqf). Checked once a second on the local
// player's current unit only - never every unit in the mission - and the check is a string compare on
// the animation state first, so it costs next to nothing while the player is on dry land. Polled
// like ACE does for swimming (advanced_fatigue, goggles) instead of hooking AnimChanged, which would
// need re-attaching on every respawn and unit switch.
if (hasInterface) then {
    [{
        [player] call FUNC(washOff);
    }, 1] call CBA_fnc_addPerFrameHandler;
};
