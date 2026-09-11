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

// ace_common_fnc_progressBar unconditionally calls "closeDialog 0" before drawing its own bar,
// regardless of its "_dialog" argument - it cannot be used while GVAR(Dialog) stays open, so the
// dialog flow keeps its original blind CBA_fnc_waitAndExecute delay (button "action" code runs
// unscheduled, so a blocking sleep is not legal here) instead of a visible progress bar.
switch (_level) do {
	case 1: {
		hint (localize LSTRING(applyingLayer1));
		[{
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable true;
		}, [], 2] call CBA_fnc_waitAndExecute;
	};

	case 2: {
		hint (localize LSTRING(applyingLayer2));
		[{
			((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable true;
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
