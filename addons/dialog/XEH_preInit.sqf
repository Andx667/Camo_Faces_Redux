#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(hasHelmet) = false;
GVAR(hasGoggles) = false;
GVAR(hasNV) = false;
GVAR(mirrorCam) = nil;

// The painter's animation while camo is applied through the ACE actions (fnc_getAnimation picks from
// this, fnc_startAnimation/fnc_stopAnimation play and end it). Keys are "<who>_<weapon in hand>":
// "self" = your own face, "other" = buddy painting; rifle / pistol / launcher / none = the selected
// weapon. Fill in an animation class per entry; "" = no animation for that case, the progress bar
// just runs. A move from an armed animation set (Wrfl, Wpst, Wlnr) only suits that weapon, so use one
// per weapon; a move from the unarmed set (Wnon) holsters whatever is carried, so it can be shared.
// Only played standing (the moves here start from a standing idle), never swimming, in a vehicle or
// in the air, and only if the move exists.
GVAR(animations) = createHashMapFromArray [
    // your own face: no fitting move yet, so none is played
    ["self_rifle", ""],
    ["self_pistol", ""],
    ["self_launcher", ""],
    ["self_none", ""],
    // buddy painting - unarmed, erect standing idle: weapon holstered whatever is carried
    ["other_rifle", "InBaseMoves_assemblingVehicleErc"],
    ["other_pistol", "InBaseMoves_assemblingVehicleErc"],
    ["other_launcher", "InBaseMoves_assemblingVehicleErc"],
    ["other_none", "InBaseMoves_assemblingVehicleErc"]
];

private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];

[
    QGVAR(useAceActions), "CHECKBOX",
    [LLSTRING(settingUseAceActions_name), LLSTRING(settingUseAceActions_tooltip)],
    _category,
    false,
    2
] call CBA_fnc_addSetting;

// isGlobal 1 (all clients share it) - unlike useAceActions above, whether players may paint or clean
// each other is mission rules, not a personal UI preference, so a server/mission can turn it off for
// everyone
[
    QGVAR(allowPaintingOthers), "CHECKBOX",
    [LLSTRING(settingAllowPaintingOthers_name), LLSTRING(settingAllowPaintingOthers_tooltip)],
    _category,
    true,
    1
] call CBA_fnc_addSetting;

// "<name> painted your face" and friends, sent to the target's machine by fnc_applyCamoLayer.sqf and
// fnc_cleanBuddy.sqf - the painter's own machine can't hint someone else's player
[QGVAR(notifyTarget), {
    params ["_stringKey", "_painterName"];
    hint format [localize _stringKey, _painterName];
}] call CBA_fnc_addEventHandler;
