#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Plays the painter's animation for one layer of camo, if there is one for the situation (see
 * fnc_getAnimation): a single short action - a dab of paint - per layer, so it is called at the start
 * of every layer (fnc_applyCamoLayer's bars, fnc_cleanBuddy's bar, the dialog's layer buttons) rather
 * than kept running. When painting someone else the painter first turns to face them.
 *
 * Every entry in GVAR(animations) is an action (CfgMovesBasic >> ManActions) played through ACE's
 * doGesture (playActionNow), global in effect - other players see it. The game resolves the action
 * for the painter's current stance and weapon: PutDown is a short reach-forward move with whatever is
 * in hand, GestureWipeFace (ace_goggles) an upper-body gesture. Both are shorter than a layer. The
 * painter is marked as animating for the length of a layer, so fnc_stopAnimation can cut a cancelled
 * layer's animation short.
 *
 * Arguments:
 * 0: Painter <OBJECT>
 * 1: Unit whose face is painted (default: the painter) <OBJECT>
 *
 * Return Value:
 * Whether an animation was played <BOOLEAN>
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

[_painter, _animation] call ace_common_fnc_doGesture;

// until when it may still be playing - the table's animations are all shorter than a 2 s layer, so
// afterwards fnc_stopAnimation leaves the painter alone instead of cutting some unrelated gesture
_painter setVariable [QGVAR(animating), diag_tickTime + 2];

true
