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

// give next button free or set camo face
switch (_level) do {
	case 1: {
		// allow second button
		hint "applying layer one...";
		sleep 2;
		private _button2 = (findDisplay 311) displayCtrl 5363;
		_button2 ctrlEnable true;
		hint "done!";
	};

	case 2: {
		// allow second button
		hint "applying layer two...";
		sleep 2;
		private _button3 = (findDisplay 311) displayCtrl 5364;
		_button3 ctrlEnable true;
		hint "done!";
	};

	case 3: {
		hint "applying layer three...";
		sleep 2;
		private _lbCamo = (findDisplay 311) displayCtrl 5263;
		[player, (_lbCamo lbData (lbCurSel _lbCamo))] call EFUNC(common,setCamo);
		hint "camo face applied";
		private _d_button1 = (findDisplay 311) displayCtrl 5362;
		private _d_button2 = (findDisplay 311) displayCtrl 5363;
		private _d_button3 = (findDisplay 311) displayCtrl 5364;
		_d_button1 ctrlEnable false;
		_d_button2 ctrlEnable false;
		_d_button3 ctrlEnable false;
	};
};
