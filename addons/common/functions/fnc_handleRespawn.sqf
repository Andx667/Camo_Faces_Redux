#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Extended_Respawn_EventHandlers hook (CfgEventHandlers.hpp): waits for the respawned unit to be
 * alive, then reapplies its previously-saved camo (if any). An active camo scheme goes through
 * fnc_setCamo, the same public entry point a manual reapplication would use, so this gets a fresh
 * wear-off timer too (see fnc_setCamo.sqf). Anything else (a plain saved base face, or nothing)
 * falls back to the shared cfr_common_setFace CBA event, the same mechanism XEH_postInit.sqf uses
 * on mission start.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call cfr_common_fnc_handleRespawn
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_handleRespawn",_this);

waitUntil {alive _unit};

private _scheme = _unit getVariable [QGVAR(scheme), ""];

if (_scheme != "") then {
    [_unit, _scheme] call FUNC(setCamo);
} else {
    private _face = _unit getVariable [QGVAR(face), ""];
    if (_face != "") then {
        [QGVAR(setFace), [_unit, _face]] call CBA_fnc_globalEvent;
    };
};
