#include "..\script_component.hpp"
/*
 * Authors: Andx
 * ACE interaction condition for the "Clean Face" entry on another unit: the target is valid
 * (fnc_canTargetBuddy) and currently wears one of this mod's camo faces. Needs no item - wiping paint
 * off doesn't take any.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [cursorObject] call cfr_dialog_fnc_canCleanBuddy
 *
 * Public: No
 */

params [["_target", objNull, [objNull]]];

([_target] call FUNC(canTargetBuddy)) && {[_target] call FUNC(hasCamoApplied)}
