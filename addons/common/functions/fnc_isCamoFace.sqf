#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether a face classname is one of this mod's camo variants (any scheme, including
 * vanilla DLC-provided ones if available). Shared predicate used by fnc_setCamo.sqf,
 * fnc_canShowAction.sqf, and both fnc_unsetCamo.sqf files.
 *
 * Arguments:
 * 0: Face classname <STRING>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [face player] call cfr_common_fnc_isCamoFace
 *
 * Public: No
 */

params ["_face"];
TRACE_1("fnc_isCamoFace",_this);

private _found = false;

{
	_x params ["", "_pairs"];
	if ((_pairs findIf {(_x select 1) == _face}) != -1) exitWith {
		_found = true;
	};
} forEach GVAR(schemes);

_found;
