#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Applies a camo scheme directly via ACE self-action - starts the 3-layer progress bar sequence
 * (fnc_applyCamoLayer) at layer 1.
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["BWTarn"] call cfr_dialog_fnc_applyCamoAction
 *
 * Public: No
 */

params ["_camo"];
TRACE_1("fnc_applyCamoAction",_this);

[_camo, 1] call FUNC(applyCamoLayer);
