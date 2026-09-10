#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Country Listbox <CONTROL>
 * 1: Selected Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [my_listbox, 0] call cfr_dialog_fnc_onLBCountryChanged
 *
 * Public: No
 */

params ["_lbCountry", "_selItem"];
TRACE_1("fnc_onLBCountryChanged",_this);

disableSerialization;

private _lbCamo = (findDisplay IDD_DIALOG) displayCtrl IDC_LISTBOX_CAMOFACE;

// clear the camo listbox before repopulating it
lbClear _lbCamo;

// fill with camo options available for the selected country
private _camoOptions = [(_lbCountry lbData _selItem)] call EFUNC(common,getCamoOptions);

{
	// text
	_lbCamo lbAdd (_x select 0);
	// data
	_lbCamo lbSetData [_forEachIndex, (_x select 1)];
} forEach _camoOptions;
