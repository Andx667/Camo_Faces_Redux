#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * ACE self-action condition for the "Camo Faces" menu entry (see CfgVehicles.hpp). Shows if the
 * unit's current face is either a known un-camo'd base face or one of this mod's camo faces
 * (so the action stays available to remove camo too), and the unit has at least one of the
 * facepaint items (any item that unlocks a registered scheme, cfr_common's GVAR(itemClasses)) equipped.
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

private _faceKnown = (_face in EGVAR(common,all_faces)) || ([_face] call EFUNC(common,isCamoFace));
private _hasItem = [_player, EGVAR(common,itemClasses)] call EFUNC(common,hasFacepaint);

if (_faceKnown && _hasItem) exitWith {true};

false;
