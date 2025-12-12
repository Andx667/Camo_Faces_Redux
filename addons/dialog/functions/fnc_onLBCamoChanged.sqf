#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Button <BUTTON>
 * 1: Selected Item <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [my_button] call cfr_dialog_fnc_onLBCamoChange
 *
 * Public: No
 */

params ["_lbCountry","_selItem"];
TRACE_1("fnc_onLBCamoChange",_this);

disableSerialization;

// lb actions
// controls for pictures
private _face = (face player);

if (!GVAR(hasHelmet) && !GVAR(hasGoggles) && !GVAR(hasNV) && _face in GVAR(faces)) then { //ToDo change check to local variable on player (or something better)
	// allow first button
	private _button1 = (findDisplay 311) displayCtrl 5362;
	_button1 ctrlEnable true;
};
