#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Applies a camo scheme to a unit, if the unit's current face has a variant under that scheme.
 * Public API - safe to call from other mods/missions. See addons/common/README.md for the
 * cfr_common_camoApplied event this raises on success.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "BWTarn"] call cfr_common_fnc_setCamo
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_camo", "", [""]]
];
TRACE_1("fnc_setCamo",_this);

if (isNull _unit) exitWith {};

private _face = face _unit;
private _targetFace = "";

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _camo};
if (_schemeIdx != -1) then {
    (GVAR(schemes) select _schemeIdx) params ["", "_pairs"];
    private _pairIdx = _pairs findIf {(_x select 0) == _face};
    if (_pairIdx != -1) then {
        _targetFace = (_pairs select _pairIdx) select 1;
    };
};

if (_targetFace != "") then {
    [QGVAR(setFace), [_unit, _targetFace]] call CBA_fnc_globalEvent;
    _unit setVariable [QGVAR(face), _targetFace, true];
    // public API event - see README.md. [unit, schemeId, oldFace, newFace], local-only (unlike the
    // setFace event above) - only fires on this machine, i.e. whichever client is applying its own camo
    [QGVAR(camoApplied), [_unit, _camo, _face, _targetFace]] call CBA_fnc_localEvent;
    hint (localize LSTRING(camoApplied));
} else {
    hint (localize LSTRING(invalidFace));
};
