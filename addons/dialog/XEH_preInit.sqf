#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(hasHelmet) = false;
GVAR(hasGoggles) = false;
GVAR(hasNV) = false;
GVAR(mirrorCam) = nil;

private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];
