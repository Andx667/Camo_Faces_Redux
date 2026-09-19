#include "..\script_component.hpp"
/*
 * Authors: Andx
 * ACE interaction condition for the "Paint Face" entry on another unit: the target is valid
 * (fnc_canTargetBuddy), the player carries at least one facepaint item, and the target's face is one
 * this mod can camouflage. Which schemes are then offered, and whether they can be applied right now,
 * is decided per scheme by fnc_getBuddyActions and fnc_canApplyScheme.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [cursorObject] call cfr_dialog_fnc_canPaintBuddy
 *
 * Public: No
 */

params [["_target", objNull, [objNull]]];

([_target] call FUNC(canTargetBuddy))
&& {(EGVAR(common,itemClasses) findIf {_x in uniformItems ACE_player}) != -1}
&& {face _target in EGVAR(common,all_faces)}
