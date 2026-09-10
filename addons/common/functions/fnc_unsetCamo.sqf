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

// each camo variant is the base face plus a "_cfaces_<Suffix>" tag; find which
// one matches and strip the tag back off to recover the underlying base face
private _camoSuffixes = [
    [GVAR(faces_bwtarn), "_cfaces_BWTarn"],
    [GVAR(faces_black), "_cfaces_Black"],
    [GVAR(faces_bwstripes), "_cfaces_BWStripes"],
    [GVAR(faces_usstripes), "_cfaces_USStripes"],
    [GVAR(faces_serbian), "_cfaces_Serbian"],
    [GVAR(faces_usflash), "_cfaces_USFlash"],
    [GVAR(faces_usstains), "_cfaces_USStains"]
];

private _baseFace = "";

{
    _x params ["_faceList", "_suffix"];
    if (_face in _faceList) exitWith {
        _baseFace = _face select [0, (count _face) - (count _suffix)];
    };
} forEach _camoSuffixes;

if (_baseFace != "") then {
    [QGVAR(setFace), [_unit, _baseFace]] call CBA_fnc_globalEvent;
    _unit setVariable [QGVAR(face), _baseFace, true];
    hint (localize LSTRING(camoRemoved));
} else {
    hint (localize LSTRING(invalidFace));
};
