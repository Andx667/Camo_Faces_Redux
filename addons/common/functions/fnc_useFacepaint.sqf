#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Spends one use of the unit's facepaint for the given scheme: one round of a carried facepaint stick
 * (a magazine-type item in the scheme's items[]). If the scheme accepts several kinds of stick (Black
 * and Vanilla take any of the three) it is taken from the most-used one, the way ACE itself finishes
 * the most-used stick of a kind first, and ACE's adjustMagazineAmmo removes a stick once it's empty.
 * Failing any stick, a carried legacy item (a plain CfgWeapons item) is used, which costs nothing.
 * Called by the dialog and ACE apply flows just before fnc_setCamo, once per successful application -
 * fnc_setCamo itself never spends anything, so Zeus, scripts and respawn/loadout restore stay free.
 *
 * Arguments:
 * 0: Unit whose facepaint is used (the painter) <OBJECT>
 * 1: Camo scheme id, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * Uses the unit has left for this scheme, over every kind of stick the scheme accepts (0 = now used
 * up); -1 if there is nothing to report (a legacy item was used, or is still carried once the last
 * stick is gone, so the unit is not out of paint); -2 if the unit had no usable facepaint; -3 if the
 * scheme doesn't exist <NUMBER>
 *
 * Example:
 * [ACE_player, "BWTarn"] call cfr_common_fnc_useFacepaint
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_schemeId", "", [""]]];
TRACE_1("fnc_useFacepaint",_this);

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
if (isNull _unit || {_schemeIdx == -1}) exitWith {-3};

private _itemClasses = (GVAR(schemes) select _schemeIdx) select 2;

// the magazine-type items among them (the sticks), with the ammo left in the least-used carried stick
// of each - what ACE would take the next round from
private _magazines = magazinesAmmo _unit;
private _sticks = [];
{
    private _class = _x;

    if (isClass (configFile >> "CfgMagazines" >> _class)) then {
        private _ammo = (_magazines select {(_x select 0) == _class && {(_x select 1) > 0}}) apply {_x select 1};

        if (_ammo isNotEqualTo []) then {
            _sticks pushBack [selectMin _ammo, _class];
        };
    };
} forEach _itemClasses;

// sorted ascending by that ammo, so the most-used stick comes first (ties fall back to the classname)
_sticks sort true;

private _fnc_usesLeft = {
    params ["_unit", "_itemClasses"];

    private _left = 0;
    {
        private _magazine = _x;
        if ((_itemClasses findIf {_x == (_magazine select 0)}) != -1) then {_left = _left + (_magazine select 1)};
    } forEach (magazinesAmmo _unit);

    _left
};

if (_sticks isNotEqualTo []) exitWith {
    private _class = (_sticks select 0) select 1;

    // returns how much ammo was adjusted by: -1 if a use was taken, 0 if there was nothing to take
    if (([_unit, _class, -1] call ace_common_fnc_adjustMagazineAmmo) == 0) exitWith {-2};

    private _left = [_unit, _itemClasses] call _fnc_usesLeft;

    // out of sticks but still carrying a legacy item: not out of paint, nothing worth reporting
    if (_left == 0 && {[_unit, _itemClasses] call FUNC(hasFacepaint)}) exitWith {-1};

    _left
};

// no stick: a legacy plain item still works, and never runs out
if ([_unit, _itemClasses] call FUNC(hasFacepaint)) exitWith {-1};

-2
