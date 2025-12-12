#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Gets the available country-specific facepaint options based on items in the unit's uniform.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * List of available country facepaint options <ARRAY of ARRAY> - Each element is [Display Name, Selection String]
 *
 * Example:
 * [player] call cfr_common_fnc_getCountryOptions
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_countryOptions",_this);

private _camolist = [];

if (EGVAR(items,BW_Facepaint) in uniformItems _unit) then {
	private _bwFacepaint = [ELSTRING(items,bw_facepaint_displayname),"bw_select"];
	_camolist pushBack _bwFacepaint;
};


if (EGVAR(items,SERBIAN_Facepaint) in uniformItems _unit) then {
	private _serbianFacepaint = [ELSTRING(items,serbian_facepaint_displayname),"serbian_select"];
	_camolist pushBack _serbianFacepaint;
};


if (EGVAR(items,US_Facepaint) in uniformItems _unit) then {
	private _usFacepaint = [ELSTRING(items,us_facepaint_displayname),"us_select"];
	_camolist pushBack _usFacepaint;
};

// return value
_camolist;
