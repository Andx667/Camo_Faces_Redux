#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Spends one use of the unit's facepaint for the given scheme: one round of a carried facepaint stick
 * (a magazine-type item in the scheme's items[]; ACE's adjustMagazineAmmo finishes the most-used
 * stick first and removes a stick once it's empty). Sticks are preferred; failing that a
 * carried legacy item (a plain CfgWeapons item) is used, which costs nothing. Called by the dialog and
 * ACE apply flows just before fnc_setCamo, once per successful application - fnc_setCamo itself never
 * spends anything, so Zeus, scripts and respawn/loadout restore stay free.
 *
 * Arguments:
 * 0: Unit whose facepaint is used (the painter) <OBJECT>
 * 1: Camo scheme id, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * Uses left in the stick just used (0 = it is now used up), -1 if nothing was spent (legacy
 * facepaint, unlimited), or -2 if the unit had no usable facepaint for the scheme <NUMBER>
 *
 * Example:
 * [ACE_player, "BWTarn"] call cfr_common_fnc_useFacepaint
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_schemeId", "", [""]]];
TRACE_1("fnc_useFacepaint",_this);

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
if (isNull _unit || {_schemeIdx == -1}) exitWith {-2};

private _itemClasses = (GVAR(schemes) select _schemeIdx) select 2;
private _magazines = magazinesAmmo _unit;

// a stick (magazine-type item) that still has a use left
private _stickIdx = _itemClasses findIf {
    private _class = _x;
    isClass (configFile >> "CfgMagazines" >> _class)
    && {(_magazines findIf {(_x select 0) == _class && {(_x select 1) > 0}}) != -1}
};

if (_stickIdx != -1) exitWith {
    private _class = _itemClasses select _stickIdx;

    // returns how much ammo was adjusted by: -1 if a use was taken, 0 if there was nothing to take
    if (([_unit, _class, -1] call ace_common_fnc_adjustMagazineAmmo) == 0) exitWith {-2};

    // what is left across every stick of that kind the unit carries
    private _left = 0;
    {
        if ((_x select 0) == _class) then {_left = _left + (_x select 1)};
    } forEach (magazinesAmmo _unit);

    _left
};

// no stick: a legacy plain item still works, and never runs out
if ([_unit, _itemClasses] call FUNC(hasFacepaint)) exitWith {-1};

-2
