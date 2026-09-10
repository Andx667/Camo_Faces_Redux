#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call cfr_common_fnc_init
 *
 * Public: No
 */

params [];
TRACE_1("fnc_init",_this);

GVAR(all_faces) = ["PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03",
			"AsianHead_A3_01","AsianHead_A3_02","AsianHead_A3_03",
			"AfricanHead_01","AfricanHead_02","AfricanHead_03",
			"GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09",
			"WhiteHead_01","WhiteHead_02","WhiteHead_03","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_09","WhiteHead_10","WhiteHead_11","WhiteHead_12","WhiteHead_13","WhiteHead_14","WhiteHead_15","WhiteHead_16","WhiteHead_17","WhiteHead_18","WhiteHead_19","WhiteHead_20","WhiteHead_21"];

// African heads have no "Black" (night) camo variant defined in cfr_faces
GVAR(faces_african) = ["AfricanHead_01", "AfricanHead_02", "AfricanHead_03"];

// each camo scheme list holds the real cfr_faces CfgFaces classnames ("cfr_faces_<BaseFace>_<Scheme>"),
// derived from the base face list so the two can't drift out of sync with each other
GVAR(faces_bwtarn) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_BWTarn"};
GVAR(faces_black) = (GVAR(all_faces) - GVAR(faces_african)) apply {FACES_CLASS_PREFIX + _x + "_Black"};
GVAR(faces_bwstripes) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_BWStripes"};
GVAR(faces_serbian) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_Serbian"};
GVAR(faces_usstripes) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_USStripes"};
GVAR(faces_usstains) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_USStains"};
GVAR(faces_usflash) = GVAR(all_faces) apply {FACES_CLASS_PREFIX + _x + "_USFlash"};


{
	private _face = _x getVariable [QGVAR(face), ""];
	if (_face != "") then {
		_x setFace _face;
	};
} forEach (allUnits + allDead);
