#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"Andx"};
        url = ECSTRING(main,url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cfr_common",
            "cfr_items",
            "zen_context_menu"
        };
        // silently don't load this PBO at all if ZEN isn't present - the rest of the mod is unaffected
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgContext.hpp"
