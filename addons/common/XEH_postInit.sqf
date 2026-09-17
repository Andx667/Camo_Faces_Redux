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
