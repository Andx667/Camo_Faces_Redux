#include "..\script_component.hpp"
/*
 * Authors: Andx
 * ACE insertChildren for the "Paint Face" entry on another unit (see CfgVehicles.hpp): one child per
 * registered camo scheme the player carries a facepaint item for and that has a variant for the
 * target's face - like fnc_getSchemeActions, built from cfr_common's GVAR(schemes) each time the menu
 * opens, so schemes added by other addons show up here too (fnc_canPaintBuddy uses the same test to
 * decide whether there is anything to show at all). Each child stays visible but greyed out
 * while fnc_canApplyScheme says no, which is what tells the painter that the target still has
 * headgear, goggles or night vision on (nobody can take another player's off).
 *
 * Arguments:
 * 0: Target (the unit being painted) <OBJECT>
 * 1: Player (not used) <OBJECT>
 * 2: Parameters (not used) <ANY>
 *
 * Return Value:
 * Children actions, as ACE expects from insertChildren <ARRAY>
 *
 * Example:
 * [cursorObject, player, []] call cfr_dialog_fnc_getBuddyActions
 *
 * Public: No
 */

params ["_target"];
TRACE_1("fnc_getBuddyActions",_this);

private _face = face _target;
private _actions = [];

{
    _x params ["_schemeId", "_pairs", "_itemClasses", "_displayName", "", "_icon"];

    if ([ACE_player, _itemClasses] call EFUNC(common,hasFacepaint) && {(_pairs findIf {(_x select 0) == _face}) != -1}) then {
        private _action = [
            format ["%1_Buddy_%2", QUOTE(ADDON), _schemeId],
            _displayName,
            _icon,
            {
                params ["", "", "_params"];
                _params call FUNC(applyCamoAction);
            },
            {
                params ["", "", "_params"];
                _params call FUNC(canApplyScheme);
            },
            {},
            [_schemeId, _target],
            {[0, 0, 0]},
            2,
            [true, false, false, false, false]
        ] call ace_interact_menu_fnc_createAction;

        _actions pushBack [_action, [], _target];
    };
} forEach EGVAR(common,schemes);

_actions
