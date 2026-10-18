#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Picks the animation the painter plays for each layer of camo (see fnc_startAnimation), from the
 * GVAR(animations) table in XEH_preInit.sqf: one entry per situation ("self" for your own face,
 * "other" for buddy painting) and per weapon in hand, so a case can be given its own animation or
 * none at all.
 *
 * Returns "" - no animation, the layer just runs - when the Enable Painting Animations setting
 * (GVAR(enableAnimations)) is off, the table has no entry for the situation,
 * the action isn't in the game's config (e.g. ace_goggles, which adds GestureWipeFace, isn't loaded),
 * or the painter isn't in a state it suits: in a vehicle, off the ground (parachute), prone or
 * swimming (where `stance` reports "UNDEFINED"), unconscious, or holding something that isn't a
 * primary, handgun or launcher (binoculars).
 *
 * Arguments:
 * 0: Painter <OBJECT>
 * 1: Unit whose face is painted (default: the painter) <OBJECT>
 *
 * Return Value:
 * Action name (CfgMovesBasic >> ManActions), or "" for none <STRING>
 *
 * Example:
 * [ACE_player, cursorObject] call cfr_dialog_fnc_getAnimation
 *
 * Public: No
 */

params ["_painter", ["_target", objNull, [objNull]]];
TRACE_2("fnc_getAnimation",_painter,_target);

if (
    !GVAR(enableAnimations)
    || {!isNull objectParent _painter}
    || {!isTouchingGround _painter}
    || {!(stance _painter in ["STAND", "CROUCH"])}
    || {_painter getVariable ["ACE_isUnconscious", false]}
) exitWith {""};

private _weapon = currentWeapon _painter;
private _kind = switch (true) do {
    case (_weapon == ""): {"none"};
    case (_weapon == primaryWeapon _painter): {"rifle"};
    case (_weapon == handgunWeapon _painter): {"pistol"};
    case (_weapon == secondaryWeapon _painter): {"launcher"};
    default {""};
};
if (_kind == "") exitWith {""};

private _who = ["other", "self"] select (isNull _target || {_target == _painter});

private _animation = GVAR(animations) getOrDefault [format ["%1_%2", _who, _kind], ""];

if (_animation == "") exitWith {""};

// an action that isn't there (a mod that provides it isn't loaded) would just not play. ManActions
// entries are plain text in vanilla (PutDown = "") and arrays where a mod adds a gesture (ACE)
private _cfg = configFile >> "CfgMovesBasic" >> "ManActions" >> _animation;
["", _animation] select (isText _cfg || {isArray _cfg})
