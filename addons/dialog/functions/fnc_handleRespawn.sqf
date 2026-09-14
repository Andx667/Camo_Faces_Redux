#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Extended_Respawn_EventHandlers hook (CfgEventHandlers.hpp): waits for the respawned unit to be
 * alive, then reapplies its previously-saved camo face (if any) via the shared cfr_common_setFace
 * CBA event - the same mechanism fnc_init.sqf uses on mission start.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call cfr_dialog_fnc_handleRespawn
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_handleRespawn",_this);

waitUntil {alive _unit};

private _face = _unit getVariable [QGVAR(face), ""];

if (_face != "") then {
    [QEGVAR(common,setFace), [_unit, _face]] call CBA_fnc_globalEvent;
};
