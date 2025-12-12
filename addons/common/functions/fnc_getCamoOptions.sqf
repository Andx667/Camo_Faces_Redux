#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Gets the available camouflage options for the current player's face based on the selected camo scheme.
 *
 * Arguments:
 * 0: Selected Camo Scheme <STRING>
 *
 * Return Value:
 * List of available camouflage options <ARRAY of ARRAY> - Each element is [Display Name, Data String]
 *
 * Example:
 * ["bw_select"] call cfr_common_fnc_getCamoOptions
 *
 * Public: No
 */

params ["_select"];
TRACE_1("fnc_getCamoOptions",_this);

//ToDO Refactor Logic for Face Selection
private _selected = [];

if (face player in GVAR(faces)) then {

	if (_select == "bw_select") then {
		if ((face player + '_cfaces_BWTarn') in GVAR(faces_bwtarn)) then {
			private _bw_tarn = [localize "STR_Camofaces_BWTarn","cfaces_BWTarn"];
			_selected pushBack _bw_tarn;
		};
		if ((face player + '_cfaces_Black') in GVAR(faces_black)) then {
			private _bw_stripes = [localize "STR_Camofaces_Night","cfaces_Black"];
			_selected pushBack _bw_stripes;
		};
		if ((face player + '_cfaces_BWStripes') in GVAR(faces_bwstripes)) then {
			private _bw_stripes = [localize "STR_Camofaces_Stripes","cfaces_BWStripes"];
			_selected pushBack _bw_stripes;
		};
	};

	if (_select == "serbian_select") then {
		if ((face player + '_cfaces_Serbian') in GVAR(faces_serbian)) then {
			private _serbian_tarn = [localize "STR_Camofaces_Serbian","cfaces_Serbian"];
			_selected pushBack _serbian_tarn;
		};
	};

	if (_select == "us_select") then {
		if ((face player + '_cfaces_USStripes') in GVAR(faces_usstripes)) then {
			private _us_stripes = [localize "STR_Camofaces_USStripes","cfaces_USStripes"];
			_selected pushBack _us_stripes;
		};
		if ((face player + '_cfaces_USStains') in GVAR(faces_usstains)) then {
			private _us_stains = [localize "STR_Camofaces_USStains","cfaces_USStains"];
			_selected pushBack _us_stains;
		};
		if ((face player + '_cfaces_USFlash') in GVAR(faces_usflash)) then {
			private _us_flash = [localize "STR_Camofaces_USFlash","cfaces_USFlash"];
			_selected pushBack _us_flash;
		};
	};

};

//return value
_selected;
