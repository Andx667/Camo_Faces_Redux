#include "..\script_component.hpp"
/*
 * Authors: Andx
 * AnimChanged handler for the local player (see XEH_postInit.sqf): washes camo off the moment the
 * player dives, if the "Will Camo Wash Off in Water" setting is on. There is no timer - the dive
 * animation starting is the trigger, so it needs no polling and has no lag.
 *
 * Diving is recognised by the animation set, the same way ACE's ace_common_fnc_isSwimming does: the
 * breath-hold (Abdv), scuba (Asdv) and other (Adve) dive sets are underwater; the surface-swim sets
 * (Aswm, Absw, Assw) are not, so swimming with your head above water leaves camo alone. Being in a
 * vehicle never matches, as vehicle animations aren't from these sets. Only a camo face is touched
 * (checked by face rather than the synced scheme variable, so camo restored from a loadout counts
 * too), and it goes through fnc_unsetCamo like any other removal - the wear-off timer is cancelled and
 * cfr_common_camoRemoved is raised.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Animation <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "advepercmstpsnonwnondnon"] call cfr_common_fnc_handleAnimChanged
 *
 * Public: No
 */

params ["_unit", "_anim"];

if (!GVAR(washOffInWater) || {!alive _unit}) exitWith {};

// animation names are lower case here; character 0 is the "A" of every set, 1-3 identify it
if !((_anim select [1, 3]) in ["bdv", "sdv", "dve"]) exitWith {};

private _face = face _unit;
if !([_face] call FUNC(isCamoFace)) exitWith {};

TRACE_2("fnc_handleAnimChanged - washing off camo",_unit,_anim);
[_unit, _face] call FUNC(unsetCamo);
