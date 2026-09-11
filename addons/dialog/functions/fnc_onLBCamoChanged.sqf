#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Camoface Listbox <CONTROL>
 * 1: Selected Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [my_listbox, 0] call cfr_dialog_fnc_onLBCamoChanged
 *
 * Public: No
 */

params ["_lbCamo","_selItem"];
TRACE_1("fnc_onLBCamoChanged",_this);

disableSerialization;

// only allow starting to apply camo once all headgear is removed and the face is one we can camo
private _face = (face player);

if (!GVAR(hasHelmet) && !GVAR(hasGoggles) && !GVAR(hasNV) && _face in EGVAR(common,all_faces)) then {
	// allow first button
	private _button1 = (findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER1;
	_button1 ctrlEnable true;
};
