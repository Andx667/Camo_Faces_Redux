#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(hasHelmet) = false;
GVAR(hasGoggles) = false;
GVAR(hasNV) = false;
GVAR(mirrorCam) = nil;

// The painter's animation for each layer of camo - one dab of paint per layer, in the dialog and the
// ACE actions alike (fnc_getAnimation picks from this, fnc_startAnimation plays it, fnc_stopAnimation
// cuts it short on cancel). Keys are "<who>_<weapon in hand>": "self" = your own face, "other" = buddy
// painting; rifle / pistol / launcher / none = the selected weapon. Each entry is an action
// (CfgMovesBasic >> ManActions) played with ACE's doGesture - the game resolves it for the painter's
// stance and weapon - and should be shorter than a layer (2 s); "" = no animation for that case. Never
// played prone, swimming, in a vehicle or in the air, and only if the action exists.
GVAR(animations) = createHashMapFromArray [
    // your own face: ACE goggles' wipe-face gesture (only with ace_goggles loaded). ACE itself only
    // plays it with a rifle (it is posed around one); used here for every weapon - see how it looks
    ["self_rifle", "GestureWipeFace"],
    ["self_pistol", "GestureWipeFace"],
    ["self_launcher", "GestureWipeFace"],
    ["self_none", "GestureWipeFace"],
    // buddy painting: the short reach-forward "put down" move, with whatever is in hand
    ["other_rifle", "PutDown"],
    ["other_pistol", "PutDown"],
    ["other_launcher", "PutDown"],
    ["other_none", "PutDown"]
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

// isGlobal 0 (each client its own, a server or mission can still force it) - the painting animations
// are cosmetic, so whether to play them is a personal preference unless a mission decides otherwise.
// Checked by fnc_getAnimation, which every animation goes through
[
    QGVAR(enableAnimations), "CHECKBOX",
    [LLSTRING(settingEnableAnimations_name), LLSTRING(settingEnableAnimations_tooltip)],
    _category,
    true,
    0
] call CBA_fnc_addSetting;

// "<name> painted your face" and friends, sent to the target's machine by fnc_applyCamoLayer.sqf and
// fnc_cleanBuddy.sqf - the painter's own machine can't hint someone else's player
[QGVAR(notifyTarget), {
    params ["_stringKey", "_painterName"];
    hint format [localize _stringKey, _painterName];
}] call CBA_fnc_addEventHandler;
