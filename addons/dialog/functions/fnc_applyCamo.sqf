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

// "_dialog = false" (progress bar's 8th argument) - the default (true) opens the bar as its own
// blocking dialog, which would conflict with GVAR(Dialog) already being open here; unlike
// fnc_applyCamoLayer.sqf's ACE-action equivalent, preconditions aren't re-checked during the bar
// (kept as a HUD-style visual replacement for the previous blind CBA_fnc_waitAndExecute delay, not a
// redesign of the dialog's own validation, which already gates each button being enabled at all)
switch (_level) do {
	case 1: {
		[
			2, [],
			{ ((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable true; },
			{},
			localize LSTRING(applyingLayer1),
			{true}, [], false
		] call ace_common_fnc_progressBar;
	};

	case 2: {
		[
			2, [],
			{ ((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable true; },
			{},
			localize LSTRING(applyingLayer2),
			{true}, [], false
		] call ace_common_fnc_progressBar;
	};

	case 3: {
		[
			2, [],
			{
				private _lbCamo = (findDisplay IDD_DIALOG) displayCtrl IDC_LISTBOX_CAMOFACE;
				[player, (_lbCamo lbData (lbCurSel _lbCamo))] call EFUNC(common,setCamo);

				((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER1) ctrlEnable false;
				((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable false;
				((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable false;
			},
			{},
			localize LSTRING(applyingLayer3),
			{true}, [], false
		] call ace_common_fnc_progressBar;
	};
};
