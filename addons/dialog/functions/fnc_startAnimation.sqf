#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Starts the painter's "applying camo" animation, if there is one for the situation (see
 * fnc_getAnimation), and remembers that it did so on the painter, so fnc_stopAnimation only undoes
 * an animation that was actually started. Called once at layer 1 of fnc_applyCamoLayer's sequence;
 * the animation then runs through all three bars. When painting someone else the painter first turns
 * to face them.
 *
 * Played through ACE's doAnimation (priority 1, playMoveNow), which is global in effect - other
 * players see it - and knows not to trample states like unconsciousness.
 *
 * Arguments:
 * 0: Painter <OBJECT>
 * 1: Unit whose face is painted (default: the painter) <OBJECT>
 *
 * Return Value:
 * Whether an animation was started <BOOLEAN>
 *
 * Example:
 * [ACE_player, cursorObject] call cfr_dialog_fnc_startAnimation
 *
 * Public: No
 */

params ["_painter", ["_target", objNull, [objNull]]];
TRACE_2("fnc_startAnimation",_painter,_target);

private _animation = [_painter, _target] call FUNC(getAnimation);
if (_animation == "") exitWith {false};

if (!isNull _target && {_target != _painter}) then {
    _painter setDir (_painter getDir _target);
};

[_painter, _animation, 1] call ace_common_fnc_doAnimation;
_painter setVariable [QGVAR(animating), true];

true
