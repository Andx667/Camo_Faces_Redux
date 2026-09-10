#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Face <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "camoface"] call cfr_common_fnc_unsetCamo
 *
 * Public: No
 */

params ["_unit", "_face"];
TRACE_1("fnc_unsetCamo",_this);

// each camo variant is "<FACES_CLASS_PREFIX><BaseFace>_<Suffix>"; find which
// list matches and strip the prefix and suffix back off to recover the base face
private _camoSuffixes = [
    [GVAR(faces_bwtarn), "_BWTarn"],
    [GVAR(faces_black), "_Black"],
    [GVAR(faces_bwstripes), "_BWStripes"],
    [GVAR(faces_usstripes), "_USStripes"],
    [GVAR(faces_serbian), "_Serbian"],
    [GVAR(faces_usflash), "_USFlash"],
    [GVAR(faces_usstains), "_USStains"]
];

private _baseFace = "";

{
    _x params ["_faceList", "_suffix"];
    if (_face in _faceList) exitWith {
        _baseFace = _face select [count FACES_CLASS_PREFIX, (count _face) - (count FACES_CLASS_PREFIX) - (count _suffix)];
    };
} forEach _camoSuffixes;

if (_baseFace != "") then {
    [QGVAR(setFace), [_unit, _baseFace]] call CBA_fnc_globalEvent;
    _unit setVariable [QGVAR(face), _baseFace, true];
    hint (localize LSTRING(camoRemoved));
} else {
    hint (localize LSTRING(invalidFace));
};
