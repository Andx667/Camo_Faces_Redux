#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Turns the result of fnc_useFacepaint into the line shown to the painter after applying camo:
 * "Facepaint: N uses left" or "Facepaint used up". Empty for legacy facepaint, which never runs out.
 *
 * Arguments:
 * 0: Uses left, as returned by fnc_useFacepaint <NUMBER>
 *
 * Return Value:
 * Localized text, or "" if there is nothing to say <STRING>
 *
 * Example:
 * [7] call cfr_common_fnc_facepaintUsesText
 *
 * Public: No
 */

params [["_left", -1, [0]]];

if (_left < 0) exitWith {""};
if (_left == 0) exitWith {localize LSTRING(facepaintUsedUp)};

format [localize ([LSTRING(facepaintUsesLeft), LSTRING(facepaintUseLeft)] select (_left == 1)), _left]
