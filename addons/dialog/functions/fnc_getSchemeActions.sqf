#include "..\script_component.hpp"
/*
 * Authors: Andx
 * ACE self-action insertChildren for the "Camo Faces" menu (see CfgVehicles.hpp): builds one child
 * action per registered camo scheme (cfr_common's GVAR(schemes), i.e. CfgCamoSchemes), so schemes
 * added by other addons show up here without this mod listing them anywhere. Each child is only
 * shown while fnc_canApplyScheme says the scheme can currently be applied, exactly as the static
 * per-scheme classes it replaces were.
 *
 * Arguments:
 * 0: Target (the player, for a self-action) <OBJECT>
 * 1: Player (not used) <OBJECT>
 * 2: Parameters (not used) <ANY>
 *
 * Return Value:
 * Children actions, as ACE expects from insertChildren <ARRAY>
 *
 * Example:
 * [player, player, []] call cfr_dialog_fnc_getSchemeActions
 *
 * Public: No
 */

params ["_target"];
TRACE_1("fnc_getSchemeActions",_this);

private _actions = [];

{
    _x params ["_schemeId", "", "", "_displayName", "", "_icon"];

    private _action = [
        format ["%1_Action_%2", QUOTE(ADDON), _schemeId],
        _displayName,
        _icon,
        {
            params ["", "", "_schemeId"];
            [_schemeId] call FUNC(applyCamoAction);
        },
        {
            params ["", "", "_schemeId"];
            [_schemeId] call FUNC(canApplyScheme);
        },
        {},
        _schemeId
    ] call ace_interact_menu_fnc_createAction;

    _actions pushBack [_action, [], _target];
} forEach EGVAR(common,schemes);

_actions
