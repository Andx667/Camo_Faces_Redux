#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Returns which categories (CfgCamoCategories - by default BW, Serbian, US, Snow Stripes and Vanilla)
 * a unit's currently equipped facepaint items unlock, as [displayName, categoryId] pairs for the
 * dialog's country listbox. A category is only offered if the unit carries one of its items AND at
 * least one scheme listed under it is both unlocked by an item the unit carries (the scheme's own
 * items, which a category doesn't have to share) and has a variant for the unit's current face -
 * otherwise the pattern list would come up empty, which is what a DLC-added face would otherwise hit
 * under Vanilla (BI authored its camo faces for the original heads only).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * List of available categories <ARRAY>
 *
 * Example:
 * [player] call cfr_common_fnc_getCountryOptions
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_getCountryOptions",_this);

private _face = face _unit;
private _camolist = [];

{
    _x params ["_categoryId", "_displayName", "_itemClasses"];

    if ([_unit, _itemClasses] call FUNC(hasFacepaint)) then {
        private _offered = GVAR(schemes) findIf {
            _x params ["", "_pairs", "_schemeItems", "", "", "", "_categories"];
            (_categories findIf {_x == _categoryId}) != -1
            && {[_unit, _schemeItems] call FUNC(hasFacepaint)}
            && {(_pairs findIf {(_x select 0) == _face}) != -1}
        };

        if (_offered != -1) then {
            _camolist pushBack [_displayName, _categoryId];
        };
    };
} forEach GVAR(categories);

// return value
_camolist;
