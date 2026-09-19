#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Applies a camo scheme directly via ACE action - starts the 3-layer progress bar sequence
 * (fnc_applyCamoLayer) at layer 1, on the player's own face or on another unit's (buddy painting).
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 * 1: Unit whose face is painted (default: ACE_player) <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["BWTarn"] call cfr_dialog_fnc_applyCamoAction
 *
 * Public: No
 */

params ["_camo", ["_target", ACE_player, [objNull]]];
TRACE_1("fnc_applyCamoAction",_this);

[_camo, 1, _target] call FUNC(applyCamoLayer);
