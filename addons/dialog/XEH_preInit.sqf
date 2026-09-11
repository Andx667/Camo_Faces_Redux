#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(hasHelmet) = false;
GVAR(hasGoggles) = false;
GVAR(hasNV) = false;
GVAR(mirrorCam) = nil;

// single source of truth for the 3 facepaint item classnames - QEGVAR expands to a fixed string at
// compile time, so this is safe to set here (unlike a table of cfr_common's face-list GVARs, which
// aren't populated until cfr_common's postInit runs and can't safely be read this early)
GVAR(itemClasses) = [QEGVAR(items,BW_Facepaint), QEGVAR(items,Serbian_Facepaint), QEGVAR(items,US_Facepaint)];

private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];

[
    QGVAR(useAceActions), "CHECKBOX",
    [LLSTRING(settingUseAceActions_name), LLSTRING(settingUseAceActions_tooltip)],
    _category,
    false,
    2
] call CBA_fnc_addSetting;
