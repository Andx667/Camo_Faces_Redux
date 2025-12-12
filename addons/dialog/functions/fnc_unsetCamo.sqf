#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit (default: player) <OBJECT>
 * 1: Camoface <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, camofaces] call cfr_dialog_fnc_unsetCamo
 *
 * Public: No
 */

params [
    ["_unit", player, [player]],
    ["_face", face player, []]
];
TRACE_1("fnc_unsetCamo",_this);

if (_face in GVAR(faces_bwtarn) || _face in GVAR(faces_black) || _face in GVAR(faces_bwstripes) ||
 _face in GVAR(faces_serbian) || _face in GVAR(faces_usstripes) || _face in GVAR(faces_usflash) ||
 _face in GVAR(faces_usstains)) then {
	[_unit, _face] call EFUNC(common,unsetCamo);
	hint "camo face removed";
} else {
	hint "no camo face applied";
};
