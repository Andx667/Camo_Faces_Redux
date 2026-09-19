#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Builds GVAR(all_faces), GVAR(schemes), GVAR(categories) and GVAR(itemClasses) from the config
 * registry (CfgCamoBaseFaces / CfgCamoSchemes / CfgCamoCategories - see CfgCamo.hpp), the single
 * shared source of truth every consumer (apply/remove, dialog UI, ACE self-actions, the ZEN compat
 * layer) reads camo scheme data from. Because it is all config, any addon can register further faces
 * or whole schemes without touching this mod - this mod's own faces are registered the same way.
 *
 * Anything that can't be used on this machine is left out rather than failing: a base face or scheme
 * whose required DLC isn't owned, and any pair naming a face class that doesn't exist (e.g. a typo,
 * or an addon that isn't loaded), so a broken registration only loses itself.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call cfr_common_fnc_init
 *
 * Public: No
 */

params [];
TRACE_1("fnc_init",_this);

// Text from a config property, localized if it is a "$STR_..." key (as CSTRING() produces) and
// left alone otherwise, so an addon can just as well write a plain string
private _fnc_getText = {
    params ["_cfg", "_default"];
    private _text = getText _cfg;
    if (_text == "") exitWith {_default};
    if (_text select [0, 1] == "$") then {_text = localize (_text select [1])};
    _text
};

// Faces that can be camouflaged and that this machine may use. requiredDLC is checked through the
// same isDLCAvailable gate the Vanilla scheme uses: a client without the DLC never gets those faces
// into GVAR(all_faces), so they vanish from every consumer at once with no DLC-specific logic
// anywhere else. (The config itself is static - the camo classes exist either way; ownership is a
// runtime concern.)
GVAR(all_faces) = [];
{
    private _dlc = getNumber (_x >> "requiredDLC");
    if (_dlc == 0 || {isDLCAvailable _dlc}) then {
        GVAR(all_faces) pushBack configName _x;
    };
} forEach configProperties [configFile >> "CfgCamoBaseFaces", "isClass _x"];

// Every face class in CfgFaces, lowercased - a registered camo face is only trusted if it really
// exists. Any CfgFaces group counts (not just Man_A3), so an addon isn't forced into one.
private _knownFaces = createHashMap;
{
    {
        _knownFaces set [toLowerANSI configName _x, true];
    } forEach configProperties [_x, "isClass _x"];
} forEach configProperties [configFile >> "CfgFaces", "isClass _x"];

// GVAR(schemes): each row is [schemeId, pairs, itemClasses, displayName, shortName, icon, categories]
//   - pairs: [[baseFace, camoFace], ...] - which base face becomes which camo face under this scheme.
//     A scheme simply has no pair for a face it doesn't cover (e.g. Black on very dark skin), which is
//     how "not offered for this face" works everywhere.
//   - itemClasses: facepaint items that unlock the scheme (carrying any one is enough)
//   - displayName / shortName: already localized; shortName is the dialog's narrower label and falls
//     back to displayName
//   - icon: ACE self-action icon
//   - categories: CfgCamoCategories ids the dialog lists the scheme under
GVAR(schemes) = [];
private _defaultIcon = QPATHTOF(data\UI\Icon_camoon_ca.paa);

{
    private _schemeCfg = _x;
    private _schemeId = configName _schemeCfg;
    private _dlc = getNumber (_schemeCfg >> "requiredDLC");

    if (_dlc == 0 || {isDLCAvailable _dlc}) then {
        private _pairs = [];
        {
            private _baseFace = configName _x;
            private _camoFace = getText _x;

            // a base face that isn't usable here (DLC not owned) just doesn't take part
            if (_baseFace in GVAR(all_faces)) then {
                if (_knownFaces getOrDefault [toLowerANSI _camoFace, false]) then {
                    _pairs pushBack [_baseFace, _camoFace];
                } else {
                    WARNING_3("scheme %1: camo face '%2' for '%3' is not a CfgFaces class, skipped",_schemeId,_camoFace,_baseFace);
                };
            };
        } forEach configProperties [_schemeCfg >> "Faces", "isText _x"];

        private _displayName = [_schemeCfg >> "displayName", _schemeId] call _fnc_getText;
        private _icon = getText (_schemeCfg >> "icon");
        if (_icon == "") then {_icon = _defaultIcon};

        GVAR(schemes) pushBack [
            _schemeId,
            _pairs,
            getArray (_schemeCfg >> "items"),
            _displayName,
            [_schemeCfg >> "shortName", _displayName] call _fnc_getText,
            _icon,
            getArray (_schemeCfg >> "categories")
        ];
    };
} forEach configProperties [configFile >> "CfgCamoSchemes", "isClass _x"];

// GVAR(categories): [categoryId, displayName, itemClasses, whiteBox] - what the dialog's first list
// shows. Whether one is actually offered depends on the unit (see fnc_getCountryOptions.sqf).
GVAR(categories) = configProperties [configFile >> "CfgCamoCategories", "isClass _x"] apply {
    [
        configName _x,
        [_x >> "displayName", configName _x] call _fnc_getText,
        getArray (_x >> "items"),
        getNumber (_x >> "whiteBox") > 0
    ]
};

// every item that unlocks anything - what "is this unit carrying any facepaint" means to the dialog
private _items = [];
{_items append (_x select 2)} forEach GVAR(schemes);
GVAR(itemClasses) = _items arrayIntersect _items;
