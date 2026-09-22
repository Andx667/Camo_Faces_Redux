#define COMPONENT items
#define COMPONENT_BEAUTIFIED Items
#include "\z\cfr\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#include "\z\cfr\addons\main\script_macros.hpp"

// facepaint picture/icon + model for a faction, shared by CfgMagazines.hpp and CfgWeapons.hpp so
// each faction's art is one source of truth instead of two
#define FACEPAINT_ART(faction) \
    picture = QPATHTOF(data\UI\gear_##faction##_Facepaint.paa); \
    model = QPATHTOF(data\##faction##_Facepaint.p3d);
