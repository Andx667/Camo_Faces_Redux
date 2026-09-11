#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Applies a random applicable camo scheme to each of the given units independently (each unit gets
 * its own random pick), skipping any unit whose current face isn't one this mod can camouflage.
 *
 * Arguments:
 * 0: Units <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[unit1, unit2]] call cfr_compat_zen_fnc_applyRandomCamo
 *
 * Public: No
 */

params ["_units"];
TRACE_1("fnc_applyRandomCamo",_this);

private _applied = 0;

{
	private _face = face _x;
	private _schemeIds = (EGVAR(common,schemes) select {(_x select 1) findIf {(_x select 0) == _face} != -1}) apply {_x select 0};

	if (_schemeIds isNotEqualTo []) then {
		[_x, selectRandom _schemeIds] call EFUNC(common,setCamo);
		_applied = _applied + 1;
	};
} forEach _units;

hint format [localize LSTRING(randomApplied), _applied, count _units];
