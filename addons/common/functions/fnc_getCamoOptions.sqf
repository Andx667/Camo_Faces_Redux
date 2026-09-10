#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Selected Camo Scheme <STRING>
 *
 * Return Value:
 * List of available Camos <ARRAY>
 *
 * Example:
 * ["bw_select"] call cfr_common_fnc_getCamoOptions
 *
 * Public: No
 */

params ["_select"];
TRACE_1("fnc_getCamoOptions",_this);

//ToDo Refactor Logic for Face Selection
private _selected = [];
private _face = face player;

if (_face in GVAR(all_faces)) then {

	if (_select == "bw_select") then {
		if ((FACES_CLASS_PREFIX + _face + "_BWTarn") in GVAR(faces_bwtarn)) then {
			_selected pushBack [localize LSTRING(camo_bwtarn), "BWTarn"];
		};
		if ((FACES_CLASS_PREFIX + _face + "_Black") in GVAR(faces_black)) then {
			_selected pushBack [localize LSTRING(camo_black), "Black"];
		};
		if ((FACES_CLASS_PREFIX + _face + "_BWStripes") in GVAR(faces_bwstripes)) then {
			_selected pushBack [localize LSTRING(camo_bwstripes), "BWStripes"];
		};
	};

	if (_select == "serbian_select") then {
		if ((FACES_CLASS_PREFIX + _face + "_Serbian") in GVAR(faces_serbian)) then {
			_selected pushBack [localize LSTRING(camo_serbian), "Serbian"];
		};
	};

	if (_select == "us_select") then {
		if ((FACES_CLASS_PREFIX + _face + "_USStripes") in GVAR(faces_usstripes)) then {
			_selected pushBack [localize LSTRING(camo_usstripes), "USStripes"];
		};
		if ((FACES_CLASS_PREFIX + _face + "_USStains") in GVAR(faces_usstains)) then {
			_selected pushBack [localize LSTRING(camo_usstains), "USStains"];
		};
		if ((FACES_CLASS_PREFIX + _face + "_USFlash") in GVAR(faces_usflash)) then {
			_selected pushBack [localize LSTRING(camo_usflash), "USFlash"];
		};
	};

};

//return value
_selected;
