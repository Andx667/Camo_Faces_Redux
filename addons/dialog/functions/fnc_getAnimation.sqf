#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Picks the animation the painter plays while applying camo (see fnc_startAnimation), from the
 * GVAR(animations) table in XEH_preInit.sqf: one entry per situation ("self" for your own face,
 * "other" for buddy painting) and per weapon in hand, so an armed move can be given per weapon while
 * an unarmed one (which holsters whatever is carried) is just repeated.
 *
 * Returns "" - no animation, the progress bar just runs - when the table has no entry for the
 * situation, the move isn't in the game's config (e.g. an ACE component was removed), or the painter
 * isn't in a state the moves suit: in a vehicle, off the ground (parachute), not standing (crouched,
 * prone, or swimming, where `stance` reports "UNDEFINED" - the table's moves start from a standing
 * idle), unconscious, or holding something that isn't a primary, handgun or launcher (binoculars).
 *
 * Arguments:
 * 0: Painter <OBJECT>
 * 1: Unit whose face is painted (default: the painter) <OBJECT>
 *
 * Return Value:
 * Animation class, or "" for none <STRING>
 *
 * Example:
 * [ACE_player, cursorObject] call cfr_dialog_fnc_getAnimation
 *
 * Public: No
 */

params ["_painter", ["_target", objNull, [objNull]]];
TRACE_2("fnc_getAnimation",_painter,_target);

if (
    !isNull objectParent _painter
    || {!isTouchingGround _painter}
    || {stance _painter != "STAND"}
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

// a move that isn't there (ACE without its field rations component) would just not play
["", _animation] select isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _animation)
