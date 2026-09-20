#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * ACE self-action condition for the "Camo Faces" menu entry (see CfgVehicles.hpp). Shows while the
 * unit is wearing one of this mod's camo faces, whether or not it still carries facepaint - a stick is
 * removed when its last use is spent, and camo must stay removable after that. Otherwise it shows for a
 * known un-camo'd base face when the unit carries at least one of the facepaint items (any item that
 * unlocks a registered scheme, cfr_common's GVAR(itemClasses)).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [player] call cfr_dialog_fnc_canShowAction
 *
 * Public: No
 */

params ["_player"];
TRACE_1("fnc_canShowAction",_this);

private _face = face _player;

// camo can always be taken off; putting it on needs a base face and facepaint
if ([_face] call EFUNC(common,isCamoFace)) exitWith {true};

(_face in EGVAR(common,all_faces)) && {[_player, EGVAR(common,itemClasses)] call EFUNC(common,hasFacepaint)};
