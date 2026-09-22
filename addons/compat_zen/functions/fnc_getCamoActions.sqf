#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Builds the dynamic ZEN context menu children for the "Camouflage" action, based on the currently
 * selected Zeus objects/groups: one action per available scheme if exactly one applicable unit is
 * selected, or a single "Apply Random Camouflage" action if more than one is selected. Also adds
 * "Remove Camouflage" if any selected unit currently has a camo face applied.
 *
 * Bypasses the item/headgear preconditions the dialog and ACE-action flows enforce - as Zeus, you can
 * set a unit's face directly, the same way the built-in Identity attribute can.
 *
 * Arguments:
 * 0: Selected Zeus objects <ARRAY>
 * 1: Selected Zeus groups <ARRAY>
 *
 * Return Value:
 * ZEN context menu action entries <ARRAY>
 *
 * Example:
 * [_objects, _groups] call cfr_compat_zen_fnc_getCamoActions
 *
 * Public: No
 */

params ["_objects", "_groups"];
TRACE_1("fnc_getCamoActions",_this);

private _groupUnits = [];
{_groupUnits append units _x} forEach _groups;

private _units = (_objects + _groupUnits) select {_x isKindOf "CAManBase" && {alive _x}};
_units = _units arrayIntersect _units; // dedupe - a unit can be in both _objects and a selected group

if (_units isEqualTo []) exitWith {[]};

private _actions = [];
private _applicable = _units select {face _x in EGVAR(common,all_faces)};

if (count _applicable == 1) then {
    private _unit = _applicable select 0;
    private _face = face _unit;

    {
        _x params ["_schemeId", "_pairs", "_itemClasses"];
        if (([_pairs, _face] call EFUNC(common,getCamoFace)) != "") then {
            // Use the unlocking item's own inventory icon so each scheme is visually distinct
            // instead of every entry sharing ICON_CAMOUFLAGE. Most schemes have exactly one
            // itemClasses entry; Black and the Vanilla rows list all three facepaint items since
            // they aren't tied to a single one, so those just pick the first (BW) as a stand-in.
            private _icon = "";
            if (_itemClasses isNotEqualTo []) then {
                // an item is a CfgMagazines stick or a CfgWeapons legacy item, so look in both
                private _itemClass = _itemClasses select 0;
                _icon = getText (configFile >> "CfgMagazines" >> _itemClass >> "picture");
                if (_icon == "") then {_icon = getText (configFile >> "CfgWeapons" >> _itemClass >> "picture")};
            };
            if (_icon == "") then {_icon = ICON_CAMOUFLAGE};

            private _action = [
                _schemeId,
                [_schemeId] call EFUNC(common,getSchemeDisplayName),
                _icon,
                {_args call EFUNC(common,setCamo)},
                {true},
                [_unit, _schemeId]
            ] call zen_context_menu_fnc_createAction;

            _actions pushBack [_action, [], 0];
        };
    } forEach EGVAR(common,schemes);
} else {
    if (count _applicable > 1) then {
        // _args here IS the units array (one single argument), unlike the per-scheme action above where
        // _args is itself a params array ([_unit, _schemeId]) - so it has to be wrapped in one more
        // array at the call site, or fnc_applyRandomCamo's own "params [\"_units\"]" would unpack the
        // array's first element (a unit object) as _units instead of the whole array
        private _action = [
            "RandomCamo",
            localize LSTRING(applyRandom),
            ICON_CAMOUFLAGE,
            {[_args] call FUNC(applyRandomCamo)},
            {true},
            _applicable
        ] call zen_context_menu_fnc_createAction;

        _actions pushBack [_action, [], 0];
    };
};

private _camoUnits = _units select {[face _x] call EFUNC(common,isCamoFace)};
if (_camoUnits isNotEqualTo []) then {
    private _action = [
        "RemoveCamo",
        localize LSTRING(removeCamo),
        ICON_CAMOUFLAGE,
        {[_args] call FUNC(removeCamo)},
        {true},
        _camoUnits
    ] call zen_context_menu_fnc_createAction;

    _actions pushBack [_action, [], 0];
};

_actions
