#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Camo scheme suffix, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "BWTarn"] call cfr_common_fnc_setCamo
 *
 * Public: No
 */

params ["_unit", "_camo"];
TRACE_1("fnc_setCamo",_this);

private _face = (FACES_CLASS_PREFIX + face _unit + "_" + _camo);

if ([_face] call FUNC(isCamoFace)) then {
	[QGVAR(setFace), [_unit, _face]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(face), _face, true];
	hint (localize LSTRING(camoApplied));
} else {
	hint (localize LSTRING(invalidFace));
};
