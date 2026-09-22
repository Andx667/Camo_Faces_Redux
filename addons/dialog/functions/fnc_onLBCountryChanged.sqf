#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * onLBSelChanged handler for the country listbox (Dialog.hpp). Repopulates the camo-pattern
 * listbox with whatever cfr_common's fnc_getCamoOptions returns for the newly selected
 * country/group. Also swaps the paint-box picture to the SnowStripes white-swatch texture when
 * a whiteBox category (CfgCamoCategories, i.e. snow) is what's newly selected (and back to the default brown one otherwise) - keyed
 * off the actual selection rather than just whether the player happens to be carrying the item,
 * so having multiple facepaint items at once doesn't leave the wrong box showing while a
 * different scheme is selected.
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

private _display = findDisplay IDD_DIALOG;
private _lbCamo = _display displayCtrl IDC_LISTBOX_CAMOFACE;
private _selectId = _lbCountry lbData _selItem;

// clear the camo listbox before repopulating it
lbClear _lbCamo;

// fill with camo options available for the selected country
private _camoOptions = [_selectId] call EFUNC(common,getCamoOptions);

// white-swatch box for a category flagged whiteBox in CfgCamoCategories (see header comment above)
private _box = _display displayCtrl IDC_PICTURE_BOX;
private _whiteBox = (EGVAR(common,categories) findIf {(_x select 0) == _selectId && {_x select 3}}) != -1;
_box ctrlSetText (if (_whiteBox) then {
    DAY_NIGHT_TEX(data\UI\box_snow.paa, data\UI\box_snow_night.paa)
} else {
    DAY_NIGHT_TEX(data\UI\box.paa, data\UI\box_night.paa)
});

{
    // text
    _lbCamo lbAdd (_x select 0);
    // data
    _lbCamo lbSetData [_forEachIndex, (_x select 1)];
} forEach _camoOptions;
