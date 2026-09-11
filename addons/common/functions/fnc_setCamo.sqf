#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
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

private _face = face _unit;
private _targetFace = "";

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _camo};
if (_schemeIdx != -1) then {
	(GVAR(schemes) select _schemeIdx) params ["", "_pairs"];
	private _pairIdx = _pairs findIf {(_x select 0) == _face};
	if (_pairIdx != -1) then {
		_targetFace = (_pairs select _pairIdx) select 1;
	};
};

if (_targetFace != "") then {
	[QGVAR(setFace), [_unit, _targetFace]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(face), _targetFace, true];
	// public API event - see docs/api.md. [unit, schemeId, oldFace, newFace], broadcast the same way
	// as the internal setFace event, so other mods see it on every machine regardless of who applied it
	[QGVAR(camoApplied), [_unit, _camo, _face, _targetFace]] call CBA_fnc_globalEvent;
	hint (localize LSTRING(camoApplied));
} else {
	hint (localize LSTRING(invalidFace));
};
