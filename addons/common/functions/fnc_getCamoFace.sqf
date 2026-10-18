#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Looks up the camo face a scheme's pairs list maps a given base face to, i.e. whether that scheme
 * has a variant for that face at all. Shared by every consumer that needs to know "does this scheme
 * cover this face" (dialog listboxes, ACE self/buddy actions, the ZEN compat layer, fnc_setCamo)
 * instead of each re-walking a scheme's pairs with its own findIf.
 *
 * Arguments:
 * 0: A scheme's pairs, [[baseFace, camoFace], ...] (GVAR(schemes) row element 1) <ARRAY>
 * 1: Base face to look up <STRING>
 *
 * Return Value:
 * The camo face for that base face, or "" if the scheme has no pair for it <STRING>
 *
 * Example:
 * [_pairs, face player] call cfr_common_fnc_getCamoFace
 *
 * Public: No
 */

params [["_pairs", [], [[]]], ["_face", "", [""]]];

private _pairIdx = _pairs findIf {(_x select 0) == _face};
if (_pairIdx == -1) exitWith {""};
(_pairs select _pairIdx) select 1;
