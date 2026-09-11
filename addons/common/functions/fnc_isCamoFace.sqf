#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether a face classname is one of this mod's camo variants (any scheme). Shared predicate
 * for the "is this a camo face" check that used to be copy-pasted as a 7-way OR chain in
 * fnc_setCamo.sqf, fnc_canShowAction.sqf, and both fnc_unsetCamo.sqf files.
 *
 * Arguments:
 * 0: Face classname <STRING>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [face player] call cfr_common_fnc_isCamoFace
 *
 * Public: No
 */

params ["_face"];
TRACE_1("fnc_isCamoFace",_this);

(
    _face in GVAR(faces_bwtarn) ||
    _face in GVAR(faces_black) ||
    _face in GVAR(faces_bwstripes) ||
    _face in GVAR(faces_serbian) ||
    _face in GVAR(faces_usstripes) ||
    _face in GVAR(faces_usstains) ||
    _face in GVAR(faces_usflash)
);
