#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * "Remove camo" button handler (Dialog.hpp). Thin wrapper around cfr_common's fnc_unsetCamo: only
 * forwards to it (and hints accordingly) if the given/current face is actually one of this mod's
 * camo faces, per cfr_common's fnc_isCamoFace.
 *
 * Arguments:
 * 0: Unit (default: player) <OBJECT>
 * 1: Camoface <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, camofaces] call cfr_dialog_fnc_unsetCamo
 *
 * Public: No
 */

params [
    ["_unit", player, [player]],
    ["_face", face player, [""]]
];
TRACE_1("fnc_unsetCamo",_this);

if ([_face] call EFUNC(common,isCamoFace)) then {
    [_unit, _face] call EFUNC(common,unsetCamo);
} else {
    hint (localize LSTRING(noCamoApplied));
};
