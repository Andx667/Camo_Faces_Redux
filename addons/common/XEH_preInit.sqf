#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Builds GVAR(schemes) here (preInit) rather than postInit specifically so it exists before any
// mission entity - and therefore any unit's init field - runs. See fnc_init.sqf for the full reason.
call FUNC(init);

// private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];

// #include "initSettings.inc.sqf"
// #include "initKeybinds.inc.sqf"
