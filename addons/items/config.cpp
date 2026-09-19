#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"Andx"};
        url = ECSTRING(main,url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cfr_main",
            "A3_Data_F",
            "A3_Weapons_F",
            "ace_common",
            "cba_common"
        };
        units[] = {
            QGVAR(box),
        };
        weapons[] = {
            QGVAR(US_Facepaint),
            QGVAR(BW_Facepaint),
            QGVAR(SERBIAN_Facepaint),
            QGVAR(SnowStripes_Facepaint),
        };
        magazines[] = {
            QGVAR(US_FacepaintStick),
            QGVAR(BW_FacepaintStick),
            QGVAR(Serbian_FacepaintStick),
            QGVAR(SnowStripes_FacepaintStick),
        };
        VERSION_CONFIG;
    };
};

#include "CfgWeapons.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"
