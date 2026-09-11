#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Face <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "camoface"] call cfr_common_fnc_unsetCamo
 *
 * Public: No
 */

params ["_unit", "_face"];
TRACE_1("fnc_unsetCamo",_this);

// reverse lookup: find whichever scheme's pairs has a camo value matching the current face, and
// return its paired base face - no string/suffix manipulation needed since GVAR(schemes) already
// stores both ends of the pair
private _baseFace = "";

{
	_x params ["", "_pairs"];
	private _pairIdx = _pairs findIf {(_x select 1) == _face};
	if (_pairIdx != -1) exitWith {
		_baseFace = (_pairs select _pairIdx) select 0;
	};
} forEach GVAR(schemes);

if (_baseFace != "") then {
	[QGVAR(setFace), [_unit, _baseFace]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(face), _baseFace, true];
	hint (localize LSTRING(camoRemoved));
} else {
	hint (localize LSTRING(invalidFace));
};
