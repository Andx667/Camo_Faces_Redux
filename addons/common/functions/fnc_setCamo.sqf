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
// XEH_preInit.sqf) is 0 by default, meaning disabled. Only player-controlled units get a timer: AI
// can't reapply camo by themselves, so wearing it off would just strip it for good. The timer runs on
// whichever machine owns the unit (see fnc_startWearOff.sqf), not necessarily the one calling this -
// so a Zeus applying camo to a player doesn't leave the timer on the curator's machine, where it
// would die with them and never give the player the wear-off hint.
if (GVAR(wearOffTime) > 0 && {isPlayer _unit}) then {
    [QGVAR(startWearOff), [_unit, _targetFace, _camoId], _unit] call CBA_fnc_targetEvent;
};
