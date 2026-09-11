#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// isGlobal 2 (not synced) - matches cfr_dialog's useAceActions setting, since this is a per-curator
// UI preference, not mission state that needs to agree across clients
[
    QGVAR(enableContextActions), "CHECKBOX",
    [LLSTRING(settingEnabled_name), LLSTRING(settingEnabled_tooltip)],
    [QUOTE(MOD_NAME), LLSTRING(settingCategory)],
    true,
    2
] call CBA_fnc_addSetting;
