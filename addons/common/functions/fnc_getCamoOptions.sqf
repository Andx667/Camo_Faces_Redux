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
		if ((_face + "_cfaces_BWTarn") in GVAR(faces_bwtarn)) then {
			_selected pushBack [localize LSTRING(camo_bwtarn), "cfaces_BWTarn"];
		};
		if ((_face + "_cfaces_Black") in GVAR(faces_black)) then {
			_selected pushBack [localize LSTRING(camo_black), "cfaces_Black"];
		};
		if ((_face + "_cfaces_BWStripes") in GVAR(faces_bwstripes)) then {
			_selected pushBack [localize LSTRING(camo_bwstripes), "cfaces_BWStripes"];
		};
	};

	if (_select == "serbian_select") then {
		if ((_face + "_cfaces_Serbian") in GVAR(faces_serbian)) then {
			_selected pushBack [localize LSTRING(camo_serbian), "cfaces_Serbian"];
		};
	};

	if (_select == "us_select") then {
		if ((_face + "_cfaces_USStripes") in GVAR(faces_usstripes)) then {
			_selected pushBack [localize LSTRING(camo_usstripes), "cfaces_USStripes"];
		};
		if ((_face + "_cfaces_USStains") in GVAR(faces_usstains)) then {
			_selected pushBack [localize LSTRING(camo_usstains), "cfaces_USStains"];
		};
		if ((_face + "_cfaces_USFlash") in GVAR(faces_usflash)) then {
			_selected pushBack [localize LSTRING(camo_usflash), "cfaces_USFlash"];
		};
	};

};

//return value
_selected;
