#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Consumes one use of the painter's facepaint and applies the scheme to the target, hinting
 * "invalid face"/"no facepaint" instead if there is nothing usable left. Shared by fnc_applyCamo.sqf
 * (dialog flow, always self) and fnc_applyCamoLayer.sqf (ACE self/buddy action), both of which finish
 * a layered apply sequence the same way.
 *
 * Arguments:
 * 0: Painter whose facepaint is spent <OBJECT>
 * 1: Target whose face is painted <OBJECT>
 * 2: Camo scheme id, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * Uses-left text (possibly "") once applied, or false if there was nothing usable to apply, already
 * hinted to the painter <STRING|BOOLEAN>
 *
 * Example:
 * [ACE_player, ACE_player, "BWTarn"] call cfr_dialog_fnc_finishApplyCamo
 *
 * Public: No
 */

params ["_painter", "_target", "_camo"];
TRACE_1("fnc_finishApplyCamo",_this);

// one use of the painter's facepaint stick pays for it (legacy plain items cost nothing);
// fnc_setCamo itself never spends any, so Zeus and scripts stay free
private _left = [_painter, _camo] call EFUNC(common,useFacepaint);
// -2: no usable facepaint any more (it was moved or used up while the bar(s) ran); anything else
// negative (except -1, "nothing to report") is a scheme that doesn't exist
if (_left < -1) exitWith {
    hint (localize ([ELSTRING(common,invalidFace), ELSTRING(common,noFacepaint)] select (_left == -2)));
    false
};

[_target, _camo] call EFUNC(common,setCamo);
[_left] call EFUNC(common,facepaintUsesText);
