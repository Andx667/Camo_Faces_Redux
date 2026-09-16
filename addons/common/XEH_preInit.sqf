#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Builds GVAR(schemes) here (preInit) rather than postInit specifically so it exists before any
// mission entity - and therefore any unit's init field - runs. See fnc_init.sqf for the full reason.
call FUNC(init);

private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];

// isGlobal 1 (all clients share the same setting) - unlike cfr_dialog's/cfr_compat_zen's isGlobal 2
// per-client UI preferences, how long camo takes to wear off is mission-balance state read locally
// by fnc_setCamo.sqf, so every applying client needs the same value or camo would fade at different
// times depending on who applied it
[
    QGVAR(wearOffTime), "SLIDER",
    [LLSTRING(settingWearOffTime_name), LLSTRING(settingWearOffTime_tooltip)],
    _category,
    [0, 240, 0, 0],
    1
] call CBA_fnc_addSetting;
