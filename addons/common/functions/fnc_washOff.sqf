#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Washes camo off a unit that is swimming or diving, if the "Will Camo Wash Off in Water" setting is
 * on. Called about once a second on the local player by the per-frame handler in XEH_postInit.sqf.
 *
 * Swimming is ace_common_fnc_isSwimming: the surface-swim and dive animation sets, so wading and
 * vehicles never count. Only a camo face is touched (checked by face rather than the synced scheme
 * variable, so camo restored from a loadout counts too), and it goes through fnc_unsetCamo like any
 * other removal - the wear-off timer is cancelled and cfr_common_camoRemoved is raised.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call cfr_common_fnc_washOff
 *
 * Public: No
 */

params ["_unit"];

if (!GVAR(washOffInWater) || {!alive _unit} || {!(_unit call ace_common_fnc_isSwimming)}) exitWith {};

private _face = face _unit;
if !([_face] call FUNC(isCamoFace)) exitWith {};

TRACE_1("fnc_washOff - washing off camo",_unit);
[_unit, _face] call FUNC(unsetCamo);
