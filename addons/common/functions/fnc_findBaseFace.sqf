#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Reverse lookup: finds whichever scheme's pairs has a camo value matching the given face, and
 * returns its paired base face and scheme id - no string/suffix manipulation needed since
 * GVAR(schemes) already stores both ends of the pair. Shared by fnc_isCamoFace.sqf (which only needs
 * to know whether a match exists) and fnc_unsetCamo.sqf (which also needs the base face to restore).
 *
 * Arguments:
 * 0: Camo face classname <STRING>
 *
 * Return Value:
 * [schemeId, baseFace], or ["", ""] if no scheme has a pair with that camo face <ARRAY>
 *
 * Example:
 * [face player] call cfr_common_fnc_findBaseFace
 *
 * Public: No
 */

params [["_camoFace", "", [""]]];

private _schemeId = "";
private _baseFace = "";

{
    _x params ["_id", "_pairs"];
    private _pairIdx = _pairs findIf {(_x select 1) == _camoFace};
    if (_pairIdx != -1) exitWith {
        _schemeId = _id;
        _baseFace = (_pairs select _pairIdx) select 0;
    };
} forEach GVAR(schemes);

[_schemeId, _baseFace]
