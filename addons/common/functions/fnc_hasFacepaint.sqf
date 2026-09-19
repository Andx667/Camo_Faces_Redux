#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Checks whether a unit carries facepaint that can be used, out of a list of item classes (a scheme's
 * or category's items[]). Two kinds of item can be listed: a plain item (CfgWeapons, the legacy
 * facepaint - never runs out) counts if it's anywhere in the unit's uniform, vest or backpack, and a
 * magazine-type item (CfgMagazines, the facepaint sticks - each round is one use) counts only while it
 * still has a use left. Loaded/empty ones don't count.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item classes, e.g. a scheme's itemClasses <ARRAY of STRINGS>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [ACE_player, ["cfr_items_BW_FacepaintStick", "cfr_items_BW_Facepaint"]] call cfr_common_fnc_hasFacepaint
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_itemClasses", [], [[]]]];

if (isNull _unit || {_itemClasses isEqualTo []}) exitWith {false};

private _plainItems = items _unit;
private _magazines = magazinesAmmo _unit;

(_itemClasses findIf {
    private _class = _x;
    (_class in _plainItems) || {(_magazines findIf {(_x select 0) == _class && {(_x select 1) > 0}}) != -1}
}) != -1
