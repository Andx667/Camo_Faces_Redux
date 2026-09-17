#include "script_component.hpp"

[QGVAR(setFace), {
    params ["_unit", "_face"];
    _unit setFace _face;
}] call CBA_fnc_addEventHandler;

// Reapply each unit's saved camo face (e.g. after respawn/persistence) - needs units to actually
// exist, unlike GVAR(schemes) construction itself, which now happens in XEH_preInit (see fnc_init.sqf)
{
    private _face = _x getVariable [QGVAR(face), ""];
    if (_face != "") then {
        _x setFace _face;
    };
} forEach (allUnits + allDead);

// Hook into CBA's Extended Loadout framework (CBA_fnc_getLoadout/CBA_fnc_setLoadout) so a saved
// camo face rides along whenever something exports/imports a loadout through that framework (e.g.
// ACE Arsenal's loadout export, or a mission's own loadout persistence) - GVAR(face) is otherwise
// only preserved via the unit-variable + reapply loop above, which doesn't cover that round trip.
// Both events are CBA_fnc_localEvent, same as fnc_setCamo/fnc_unsetCamo's public API events - they
// only fire on whichever machine actually calls CBA_fnc_getLoadout/CBA_fnc_setLoadout.
["CBA_loadoutGet", {
    params ["_unit", "", "_extendedInfo"];
    private _face = _unit getVariable [QGVAR(face), ""];
    if (_face != "") then {
        _extendedInfo set [QGVAR(face), _face];
    };
}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "", "_extendedInfo"];
    private _face = _extendedInfo getOrDefault [QGVAR(face), ""];
    if (_face != "") then {
        // networked the same way fnc_setCamo/fnc_unsetCamo apply a face, rather than calling
        // setFace directly, so every client's view of the unit stays in sync
        [QGVAR(setFace), [_unit, _face]] call CBA_fnc_globalEvent;
        _unit setVariable [QGVAR(face), _face, true];
    };
}] call CBA_fnc_addEventHandler;
