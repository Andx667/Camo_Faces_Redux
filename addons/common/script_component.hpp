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

// how long before camo wears off the player is warned that it is fading - see fnc_startWearOff.sqf.
// The wear-off time is randomised, so without this nobody can tell when it is about to go
#define WEAR_OFF_WARNING_SECONDS 60

// how often the local player is checked for swimming, which washes camo off - see fnc_washOff.sqf.
// Deliberately not every frame: a quick dip may leave camo intact, a short grace period, not a guarantee
#define WASH_OFF_CHECK_SECONDS 3
