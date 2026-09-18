#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Returns which country/group selections (BW/Serbian/US, plus Vanilla if the Marksmen DLC row is
 * present in GVAR(schemes)) a unit's currently equipped facepaint items unlock, as
 * [displayName, selectId] pairs for the dialog's country listbox. Vanilla isn't tied to one
 * specific item - any of the three unlocks it - so it's checked separately via the scheme's own
 * itemClasses row instead of the per-item checks used for the other three.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * List of available Camos <ARRAY>
 *
 * Example:
 * [player] call cfr_common_fnc_getCountryOptions
 *
 * Public: No
 */

params ["_unit"];
TRACE_1("fnc_getCountryOptions",_this);

private _uniformItems = uniformItems _unit;
private _camolist = [];

if (QEGVAR(items,BW_Facepaint) in _uniformItems) then {
    _camolist pushBack [localize ELSTRING(items,bw_facepaint_displayname), "bw_select"];
};

if (QEGVAR(items,Serbian_Facepaint) in _uniformItems) then {
    _camolist pushBack [localize ELSTRING(items,serbian_facepaint_displayname), "serbian_select"];
};

if (QEGVAR(items,US_Facepaint) in _uniformItems) then {
    _camolist pushBack [localize ELSTRING(items,us_facepaint_displayname), "us_select"];
};

// SnowStripes has its own dedicated item and only one color, so it gets its own top-level
// category here instead of being nested under one of the 3 military countries - also what lets
// fnc_onLBCountryChanged.sqf tell it apart from the other schemes to swap in the white-swatch
// paint-box texture instead of the shared brown one
if (QEGVAR(items,SnowStripes_Facepaint) in _uniformItems) then {
    _camolist pushBack [localize ELSTRING(items,snowstripes_facepaint_displayname), "snow_select"];
};

// Vanilla isn't tied to one specific item (any of the 3 unlocks it) and is only present in
// GVAR(schemes) at all if the Marksmen DLC is available - both checked via the scheme's own row,
// so this naturally disappears with no extra DLC-specific logic here.
// The face check matters as well: Vanilla's pairs are BI's own CamoHead_* faces, which exist only
// for the base game's original heads, so a unit on a DLC-added face has no Vanilla variant. Without
// this the category would still be listed and then show an empty pattern list (the other three
// categories can't hit that - every scheme they offer covers every face in GVAR(all_faces)).
// Checking the Vanilla row alone covers the category's other three schemes too: the environment
// variants exist only for base faces, which all have a plain Vanilla variant as well.
private _vanillaIdx = GVAR(schemes) findIf {(_x select 0) == "Vanilla"};
if (_vanillaIdx != -1) then {
    (GVAR(schemes) select _vanillaIdx) params ["", "_pairs", "_itemClasses"];
    private _face = face _unit;
    if ((_itemClasses findIf {_x in _uniformItems}) != -1 && {(_pairs findIf {(_x select 0) == _face}) != -1}) then {
        _camolist pushBack [localize LSTRING(camo_vanilla), "vanilla_select"];
    };
};

// return value
_camolist;
