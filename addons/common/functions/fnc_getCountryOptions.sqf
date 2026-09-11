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

private _uniformItems = uniformItems _unit;
private _camolist = [];

if (QEGVAR(items,BW_Facepaint) in _uniformItems) then {
	_camolist pushBack [localize ELSTRING(items,bw_facepaint_displayname), "bw_select"];
};

if (QEGVAR(items,Serbian_Facepaint) in _uniformItems) then {
	_camolist pushBack [localize ELSTRING(items,serbian_facepaint_displayname), "serbian_select"];
};

if (QEGVAR(items,US_Facepaint) in _uniformItems) then {
	_camolist pushBack [localize ELSTRING(items,us_facepaint_displayname), "us_select"];
};

// Vanilla isn't tied to one specific item (any of the 3 unlocks it) and is only present in
// GVAR(schemes) at all if the Marksmen DLC is available - both checked via the scheme's own row,
// so this naturally disappears with no extra DLC-specific logic here
private _vanillaIdx = GVAR(schemes) findIf {(_x select 0) == "Vanilla"};
if (_vanillaIdx != -1) then {
	(GVAR(schemes) select _vanillaIdx) params ["", "", "_itemClasses"];
	if ((_itemClasses findIf {_x in _uniformItems}) != -1) then {
		_camolist pushBack [localize LSTRING(camo_vanilla), "vanilla_select"];
	};
};

// return value
_camolist;
