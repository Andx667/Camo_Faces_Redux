#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Restores the unit's camouflage face after respawn.
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

waitUntil {alive player};
private _face = _unit getVariable [QGVAR(Face), ""];

hint _face;

if (_face != "") then {
	[_unit, format ["{_this setFace '%1'}", _face]] call jgkp_camofaces_fnc_execRemoteFnc; //ToDo Rework
};
