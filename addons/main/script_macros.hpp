// Global toggles for caching/logging
// #define DISABLE_COMPILE_CACHE
// #define DEBUG_MODE_FULL
// DEBUG_SYNCHRONOUS is defined unconditionally by ACE3's own script_macros.hpp - not redefined here.

#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

#define QQUOTE(var1) QUOTE(QUOTE(var1))

// QPATHTOF but without a leading slash
#define PATHTOF2(var1) MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\var1
#define QPATHTOF2(var1) QUOTE(PATHTOF2(var1))

#ifdef SUBCOMPONENT
    #define SUBADDON DOUBLES(ADDON,SUBCOMPONENT)

    // Update PATHTO macros to point to subaddon instead
    #undef PATHTO
    #define PATHTO(var1) \MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\SUBCOMPONENT\var1.sqf
    #undef PATHTOF
    #define PATHTOF(var1) \MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\SUBCOMPONENT\var1
    #undef PATHTO2
    #define PATHTO2(var1) MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\SUBCOMPONENT\var1.sqf
    #undef PATHTOF2
    #define PATHTOF2(var1) MAINPREFIX\PREFIX\SUBPREFIX\COMPONENT\SUBCOMPONENT\var1
#endif

#undef PREP
#ifdef DISABLE_COMPILE_CACHE
    #define LINKFUNC(x) {call FUNC(x)}
    #define PREP(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
    #define PREP_RECOMPILE_START    if (isNil "cfr_fnc_recompile") then {cfr_recompiles = []; cfr_fnc_recompile = {{call _x} forEach cfr_recompiles;}}; private _recomp = {
    #define PREP_RECOMPILE_END      }; call _recomp; cfr_recompiles pushBack _recomp;
#else
    // LINKFUNC / PREP_RECOMPILE_START / PREP_RECOMPILE_END already match ACE3's script_debug.hpp for this branch - not redefined here.
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define WEAP_XX(WEAP, COUNT) class DOUBLES(_xx,WEAP) { \
    weapon = QUOTE(WEAP); \
    count = COUNT; \
}

#define MAG_XX(MAG, COUNT) class DOUBLES(_xx,MAG) { \
    magazine = QUOTE(MAG); \
    count = COUNT; \
}

#define ITEM_XX(ITEM, COUNT) class DOUBLES(_xx,ITEM) { \
    name = QUOTE(ITEM); \
    count = COUNT; \
}

// ACE Cargo
#define CARGO_XX(ITEM, COUNT) class ITEM { \
    type = QUOTE(ITEM); \
    amount = COUNT; \
}

#define MAG_CSW(var1,var2) class DOUBLES(var1,csw): var1 { \
    scope = var2; \
    type = TYPE_MAGAZINE_PRIMARY_AND_THROW; \
}

// Debug textures, mainly for testing hiddenSelections
#define DBUG_TEX_RED "#(rgb,8,8,3)color(1,0,0,1)"
#define DBUG_TEX_GRN "#(rgb,8,8,3)color(0,1,0,1)"
#define DBUG_TEX_BLU "#(rgb,8,8,3)color(0,0,1,1)"
#define DBUG_TEX_PUR "#(rgb,8,8,3)color(1,0,1,1)"
#define DBUG_TEX_YEL "#(rgb,8,8,3)color(1,1,0,1)"

// Statements and conditions
#define CLAMP(var1,lower,upper) (lower max (var1 min upper))

// Weapon/magazine/item TYPE_* constants (TYPE_WEAPON_PRIMARY, TYPE_MAGAZINE_PRIMARY_AND_THROW, etc.)
// are provided by ACE3's own script_macros.hpp - ACE is authoritative for these, not redefined here.
