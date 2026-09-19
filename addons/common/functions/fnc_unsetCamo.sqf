#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Removes camouflage from a unit, restoring whichever base face the unit's current camo face pairs
 * with. Public API - safe to call from other mods/missions. See addons/common/README.md for the
 * cfr_common_camoRemoved event this raises on success.
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
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]],
    ["_face", "", [""]]
];
TRACE_1("fnc_unsetCamo",_this);

if (isNull _unit) exitWith {};

// see fnc_setCamo.sqf for why this self-defer exists - a safety net, not the primary fix, since this
// also reads GVAR(schemes)
if (isNil QGVAR(schemes)) exitWith {
    [FUNC(unsetCamo), _this] call CBA_fnc_execNextFrame;
};

// reverse lookup: find whichever scheme's pairs has a camo value matching the current face, and
// return its paired base face - no string/suffix manipulation needed since GVAR(schemes) already
// stores both ends of the pair
private _baseFace = "";
private _schemeId = "";

{
    _x params ["_id", "_pairs"];
    private _pairIdx = _pairs findIf {(_x select 1) == _face};
    if (_pairIdx != -1) exitWith {
        _baseFace = (_pairs select _pairIdx) select 0;
        _schemeId = _id;
    };
} forEach GVAR(schemes);

// see fnc_setCamo.sqf's _hintOwner for why this guard exists - without it, unsetting camo on a
// non-player unit (e.g. AI from a script) would pop the hint on this machine's own player instead
private _hintOwner = _unit == player;

if (_baseFace == "") exitWith {
    if (_hintOwner) then { hint (localize LSTRING(invalidFace)); };
};

// kill any pending wear-off timer - camo is coming off, so nothing should still be scheduled to
// remove it again later
private _timerId = _unit getVariable [QGVAR(wearOffTimerId), -1];
if (_timerId != -1) then {
    [_timerId] call CBA_fnc_removePerFrameHandler;
    _unit setVariable [QGVAR(wearOffTimerId), -1];
};

[QGVAR(setFace), [_unit, _baseFace]] call CBA_fnc_globalEvent;
_unit setVariable [QGVAR(face), _baseFace, true];
// no camo active any more - respawn/JIP restore (see fnc_setCamo.sqf) must not reapply it
_unit setVariable [QGVAR(scheme), "", true];
// invalidates any wear-off timer still running on another machine (see fnc_setCamo.sqf)
_unit setVariable [QGVAR(camoId), "", true];

// public API event - see README.md. [unit, schemeId, oldFace, newFace], local-only (unlike the
// setFace event above) - same shape/scope as camoApplied in fnc_setCamo.sqf
[QGVAR(camoRemoved), [_unit, _schemeId, _face, _baseFace]] call CBA_fnc_localEvent;
if (_hintOwner) then { hint (localize LSTRING(camoRemoved)); };
