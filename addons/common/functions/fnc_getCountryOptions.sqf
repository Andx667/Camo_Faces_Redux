#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * List of available Camos <ARRAY>
 *
 * Example:
 * [player] call cfr_common_fnc_getCountryOptions
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_getCountryOptions",_this);

private _camolist = [];

if (EGVAR(items,BW_Facepaint) in uniformItems _unit) then {
	_camolist pushBack [ELSTRING(items,bw_facepaint_displayname), "bw_select"];
};

if (EGVAR(items,Serbian_Facepaint) in uniformItems _unit) then {
	_camolist pushBack [ELSTRING(items,serbian_facepaint_displayname), "serbian_select"];
};

if (EGVAR(items,US_Facepaint) in uniformItems _unit) then {
	_camolist pushBack [ELSTRING(items,us_facepaint_displayname), "us_select"];
};

// return value
_camolist;
