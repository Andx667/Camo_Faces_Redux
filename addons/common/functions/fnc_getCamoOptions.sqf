#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Returns the camo schemes listed under a given category (see fnc_getCountryOptions.sqf) that the
 * player's current base face actually has a variant for, as [displayName, schemeId] pairs for the
 * dialog's camo-pattern listbox. Only offers options while
 * the player's face is a known, un-camo'd base face - switching camo schemes directly isn't
 * supported, the current one has to be removed first.
 *
 * Arguments:
 * 0: Selected category id, e.g. "bw" (a CfgCamoCategories class) <STRING>
 *
 * Return Value:
 * List of available Camos <ARRAY>
 *
 * Example:
 * ["bw"] call cfr_common_fnc_getCamoOptions
 *
 * Public: No
 */

params ["_select"];
TRACE_1("fnc_getCamoOptions",_this);

private _selected = [];
private _face = face player;

// only offer options while the player's current face is an un-camo'd base face - switching camo
// schemes directly isn't supported, remove the current one first (matches existing behavior)
if (_face in GVAR(all_faces)) then {
    // GVAR(schemes) is in config order, which is also the order the options are listed in. A scheme
    // with no pair for this face isn't offered - that is how e.g. Black is skipped on very dark skin,
    // and why Vanilla's environment variants show up for only three faces. shortName is the narrower
    // label meant for this list (it is just displayName for schemes that don't define one).
    {
        _x params ["_schemeId", "_pairs", "_itemClasses", "", "_shortName", "", "_categories"];

        // the scheme's own items gate it, not just the category's: a category can list schemes that
        // different facepaints unlock, and the dialog's apply path doesn't re-check items later
        if ((_categories findIf {_x == _select}) != -1 && {[player, _itemClasses] call FUNC(hasFacepaint)} && {([_pairs, _face] call FUNC(getCamoFace)) != ""}) then {
            _selected pushBack [_shortName, _schemeId];
        };
    } forEach GVAR(schemes);
};

//return value
_selected;
