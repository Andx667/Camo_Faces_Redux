#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether the player may paint or clean another unit's face at all, whatever the face or
 * items look like: the "Allow Painting Other Units" setting is on, the target is a living, friendly
 * man within reach, and isn't the player themselves. Friendly means the game's own notion of side
 * relations (BIS_fnc_sideIsFriendly), so AI and players alike qualify. Shared by every buddy-painting
 * condition, including the per-frame check of the progress bars.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [cursorObject] call cfr_dialog_fnc_canTargetBuddy
 *
 * Public: No
 */

params [["_target", objNull, [objNull]]];

private _painter = ACE_player;

!isNull _target
&& {GVAR(allowPaintingOthers)}
&& {_target != _painter}
&& {_painter distance _target <= BUDDY_MAX_DISTANCE}
&& {_target isKindOf "CAManBase"}
&& {alive _target}
&& {alive _painter}
&& {!(_painter getVariable ["ACE_isUnconscious", false])}
&& {[side group _painter, side group _target] call BIS_fnc_sideIsFriendly}
