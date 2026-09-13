#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call cfr_dialog_fnc_handleRespawn
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_handleRespawn",_this);

waitUntil {alive _unit};

private _face = _unit getVariable [QGVAR(face), ""];

if (_face != "") then {
    [QEGVAR(common,setFace), [_unit, _face]] call CBA_fnc_globalEvent;
};
