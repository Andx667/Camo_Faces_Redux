#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Removes camouflage from each of the given units, restoring its base face.
 *
 * Arguments:
 * 0: Units <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[unit1, unit2]] call cfr_compat_zen_fnc_removeCamo
 *
 * Public: No
 */

params ["_units"];
TRACE_1("fnc_removeCamo",_this);

{
    [_x, face _x] call EFUNC(common,unsetCamo);
} forEach _units;

hint format [localize LSTRING(removeApplied), count _units];
