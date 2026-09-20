#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Ends the animation fnc_startAnimation started: returns the painter to the default move for their
 * stance and weapon (ACE's doAnimation with "" and priority 2, the same way ACE medical ends a
 * treatment). Does nothing if no animation was started - so it is safe to call from every path out of
 * the apply sequence (finished, cancelled, ...) without disturbing an unrelated move - or if the
 * painter died or went unconscious meanwhile, when the game's own animation must win.
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

if !(_painter getVariable [QGVAR(animating), false]) exitWith {};
_painter setVariable [QGVAR(animating), false];

if (alive _painter && {!(_painter getVariable ["ACE_isUnconscious", false])}) then {
    [_painter, "", 2] call ace_common_fnc_doAnimation;
};
