#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Level <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1] call cfr_dialog_fnc_applyCamo
 *
 * Public: No
 */

params ["_level"];
TRACE_1("fnc_applyCamo",_this);

disableSerialization;

// button "action" code runs unscheduled, so a blocking sleep is not legal here -
// delay the follow-up work with CBA_fnc_waitAndExecute instead
switch (_level) do {
	case 1: {
		hint (localize LSTRING(applyingLayer1));
		[{
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable true;
			hint (localize LSTRING(layerDone));
		}, [], 2] call CBA_fnc_waitAndExecute;
	};

	case 2: {
		hint (localize LSTRING(applyingLayer2));
		[{
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable true;
			hint (localize LSTRING(layerDone));
		}, [], 2] call CBA_fnc_waitAndExecute;
	};

	case 3: {
		hint (localize LSTRING(applyingLayer3));
		[{
			private _lbCamo = (findDisplay IDD_DIALOG) displayCtrl IDC_LISTBOX_CAMOFACE;
			[player, (_lbCamo lbData (lbCurSel _lbCamo))] call EFUNC(common,setCamo);

			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER1) ctrlEnable false;
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable false;
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable false;
		}, [], 2] call CBA_fnc_waitAndExecute;
	};
};
