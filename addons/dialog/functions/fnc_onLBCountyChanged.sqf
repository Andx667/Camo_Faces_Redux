#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Handles country selection changes in the dialog listbox and populates available camo patterns.
 *
 * Arguments:
 * 0: Listbox control <CONTROL>
 * 1: Selected item index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_lbCountry, 0] call cfr_dialog_fnc_onLBCountyChanged
 *
 * Public: No
 */

params ["_lbCountry", "_selItem"];
TRACE_1("fnc_onLBCountyChanged",_this);


disableSerialization;

// lb actions
private _lbCamo = (findDisplay 311) displayCtrl 5263;

//first clear box
lbClear _lbCamo;

// fill with options
private _camoOptions = [(_lbCountry lbData _selItem)] call EFUNC(common,getCamoOptions);

{
	// text
	_lbCamo lbAdd (_x select 0);
	// data
	_lbCamo lbSetData [_forEachIndex, (_x select 1)];
} forEach _camoOptions;
