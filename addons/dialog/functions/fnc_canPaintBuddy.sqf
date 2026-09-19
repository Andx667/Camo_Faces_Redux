#include "..\script_component.hpp"
/*
 * Authors: Andx
 * ACE interaction condition for the "Paint Face" entry on another unit: the target is valid
 * (fnc_canTargetBuddy) and at least one registered scheme is both unlocked by a facepaint item the
 * player carries and has a variant for the target's face. That is the same test fnc_getBuddyActions
 * uses to build the entry's children, so the entry is never shown with nothing under it - a face can
 * be registered without every scheme (or every scheme the player has paint for) covering it. Whether a
 * listed scheme can be applied right now is decided per scheme by fnc_canApplyScheme.
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

private _face = face _target;

([_target] call FUNC(canTargetBuddy))
&& {
    EGVAR(common,schemes) findIf {
        _x params ["", "_pairs", "_itemClasses"];
        ([ACE_player, _itemClasses] call EFUNC(common,hasFacepaint)) && {(_pairs findIf {(_x select 0) == _face}) != -1}
    } != -1
}
