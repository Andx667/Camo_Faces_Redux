#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether the player's current face is one of this mod's camo variants - used as the
 * ACE self-action condition for the "Remove Camo Face Paint" action so it only shows when
 * there's actually something to remove.
 *
 * Arguments:
 * 0: Unit (default: ACE_player) <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [ACE_player] call cfr_dialog_fnc_hasCamoApplied
 *
 * Public: No
 */

params [["_unit", ACE_player, [ACE_player]]];
TRACE_1("fnc_hasCamoApplied",_this);

private _face = face _unit;

(
    _face in EGVAR(common,faces_bwtarn) ||
    _face in EGVAR(common,faces_black) ||
    _face in EGVAR(common,faces_bwstripes) ||
    _face in EGVAR(common,faces_serbian) ||
    _face in EGVAR(common,faces_usstripes) ||
    _face in EGVAR(common,faces_usflash) ||
    _face in EGVAR(common,faces_usstains)
);
