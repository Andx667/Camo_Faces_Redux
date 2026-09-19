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

// GVAR(schemes) is built by fnc_init, called from cfr_common's XEH_preInit specifically so it's
// ready before any mission entity - and therefore any unit's init field - can run (see fnc_init.sqf).
// This check should therefore never actually trigger; it's a safety net in case some other caller
// still manages to run even earlier than that (e.g. another addon's own preInit). Self-defer one
// frame rather than fail with "invalid face" so such callers don't have to know about the ordering
// or wrap every call themselves.
if (isNil QGVAR(schemes)) exitWith {
    [FUNC(setCamo), _this] call CBA_fnc_execNextFrame;
};

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

// hint is feedback for whoever just changed their OWN face (the only way this mod's own dialog/ACE
// self-action ever calls this, always with ACE_player) - it always runs on whichever machine executes
// this function, so without this guard, scripting fnc_setCamo onto other units (e.g. AI from a unit's
// init field) would incorrectly pop the hint on that machine's own player, not the (non-existent)
// player controlling the target unit
private _hintOwner = _unit == player;

if (_targetFace == "") exitWith {
    if (_hintOwner) then { hint (localize LSTRING(invalidFace)); };
};

[QGVAR(setFace), [_unit, _targetFace]] call CBA_fnc_globalEvent;
_unit setVariable [QGVAR(face), _targetFace, true];
// remembered so respawn/JIP restore (XEH_postInit.sqf, fnc_handleRespawn.sqf) can just call this
// function again instead of duplicating the wear-off scheduling below; cleared by fnc_unsetCamo.sqf
// when camo is removed, so restore never reapplies camo that was taken off
_unit setVariable [QGVAR(scheme), _camo, true];
// identifies THIS application of camo (machine + time), synced so every machine sees it - lets a
// wear-off timer below detect it has gone stale (camo removed or reapplied from another machine,
// which can't cancel this machine's local timer directly) and stand down instead of clobbering it
private _camoId = format ["%1_%2", clientOwner, diag_tickTime];
_unit setVariable [QGVAR(camoId), _camoId, true];

// public API event - see README.md. [unit, schemeId, oldFace, newFace], local-only (unlike the
// setFace event above) - only fires on this machine, i.e. whichever client is applying its own camo
[QGVAR(camoApplied), [_unit, _camo, _face, _targetFace]] call CBA_fnc_localEvent;
if (_hintOwner) then { hint (localize LSTRING(camoApplied)); };

// Real camo paint wears off over time (rain, sweat, ...) - GVAR(wearOffTime) (CBA setting, see
// XEH_preInit.sqf) is 0 by default, meaning disabled. Scheduled locally on this machine only (same
// as the hint/event above), so it won't survive this machine disconnecting before expiry. Uses a
// cancellable CBA_fnc_addPerFrameHandler (instead of CBA_fnc_waitAndExecute, which can't be
// cancelled) so fnc_unsetCamo.sqf can kill this outright the moment camo comes off - a second timer
// for this unit can never get created on top of it: every scheme's pairs (see fnc_init.sqf) map from
// the same shared set of base faces, never from another scheme's camo face, so once _targetFace above
// is a camo face, _pairs findIf above can't match it in any scheme and this function exits early
// until fnc_unsetCamo.sqf runs and restores a base face. That cancellation only reaches timers on
// the machine running fnc_unsetCamo though, so the timer also checks GVAR(camoId) itself (below).
private _wearOffMinutes = GVAR(wearOffTime);
if (_wearOffMinutes > 0) then {
    private _expiry = time + _wearOffMinutes * 60;
    private _pfhId = [{
        params ["_args", "_pfhId"];
        _args params ["_unit", "_face", "_expiry", "_camoId"];
        if (isNull _unit) exitWith {
            [_pfhId] call CBA_fnc_removePerFrameHandler;
        };
        if (_unit getVariable [QGVAR(camoId), ""] != _camoId) exitWith {
            [_pfhId] call CBA_fnc_removePerFrameHandler;
            _unit setVariable [QGVAR(wearOffTimerId), -1];
        };
        if (time >= _expiry) then {
            [_pfhId] call CBA_fnc_removePerFrameHandler;
            _unit setVariable [QGVAR(wearOffTimerId), -1];
            [_unit, _face] call FUNC(unsetCamo);
        };
    }, 1, [_unit, _targetFace, _expiry, _camoId]] call CBA_fnc_addPerFrameHandler;
    _unit setVariable [QGVAR(wearOffTimerId), _pfhId];
};
