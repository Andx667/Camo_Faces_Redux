#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Cuts the painter's layer animation (fnc_startAnimation) short when the layer is cancelled or the
 * dialog closed, through ACE's stopGesture. Does nothing unless one was played within the last layer
 * - so it is safe to call from every path out of a layer without disturbing an unrelated gesture -
 * or if the painter died or went unconscious meanwhile, when the game's own animation must win. A
 * finished layer needs no call: its animation is shorter than the layer and has already ended.
 *
 * Arguments:
 * 0: Painter <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ACE_player] call cfr_dialog_fnc_stopAnimation
 *
 * Public: No
 */

params ["_painter"];
TRACE_1("fnc_stopAnimation",_painter);

if (diag_tickTime >= _painter getVariable [QGVAR(animating), 0]) exitWith {};
_painter setVariable [QGVAR(animating), nil];

if (alive _painter && {!(_painter getVariable ["ACE_isUnconscious", false])}) then {
    [_painter] call ace_common_fnc_stopGesture;
};
