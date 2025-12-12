#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Removes the camouflage face from a unit via the dialog system.
 *
 * Arguments:
 * 0: Unit (default: player) <OBJECT>
 * 1: Current face (default: player's face) <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "PersianHead_A3_01_cfaces_BWTarn"] call cfr_dialog_fnc_unsetCamo
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
