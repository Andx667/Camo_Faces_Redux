#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Handles camo pattern selection changes in the dialog listbox.
 *
 * Arguments:
 * 0: Listbox control <CONTROL>
 * 1: Selected item index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_lbCamo, 0] call cfr_dialog_fnc_onLBCamoChanged
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
