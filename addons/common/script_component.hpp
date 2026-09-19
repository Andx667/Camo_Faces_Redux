#define COMPONENT common
#define COMPONENT_BEAUTIFIED Common
#include "\z\cfr\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#include "\z\cfr\addons\main\script_macros.hpp"

// classname prefix used by cfr_faces for its CfgFaces entries (PREFIX_COMPONENT_ pattern - see cfr_faces/script_component.hpp)
#define FACES_CLASS_PREFIX "cfr_faces_"

// how many minutes either side of the configured wear-off time a single camo application's wear-off
// timer can vary - see fnc_startWearOff.sqf. Fixed rather than a CBA setting on purpose; 0 disables
#define WEAR_OFF_VARIATION_MINUTES 10
