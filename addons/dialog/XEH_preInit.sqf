#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(hasHelmet) = false;
GVAR(hasGoggles) = false;
GVAR(hasNV) = false;
GVAR(mirrorCam) = nil;

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
