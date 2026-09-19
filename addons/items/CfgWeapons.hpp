// These plain items are the original, unlimited facepaint. They stay so missions and loadouts that already
// hold them keep working (and still unlock every scheme, without being used up), but they are
// scope 1 so they no longer show up in the arsenal or editor - new content uses the consumable
// facepaint sticks in CfgMagazines.hpp instead.
class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class GVAR(US_Facepaint): ACE_ItemCore  {
        author = AUTHOR;
        scope = 1;
        displayName = CSTRING(US_Facepaint_DisplayName);
        descriptionShort = CSTRING(US_Facepaint_descriptionShort);
        picture = QPATHTOF(data\UI\gear_US_Facepaint.paa);
        model = QPATHTOF(data\US_Facepaint.p3d);

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };
    class GVAR(Serbian_Facepaint): GVAR(US_Facepaint) {
        displayName = CSTRING(Serbian_Facepaint_DisplayName);
        descriptionShort = CSTRING(Serbian_Facepaint_descriptionShort);
        picture = QPATHTOF(data\UI\gear_SERBIAN_Facepaint.paa);
        model = QPATHTOF(data\SERBIAN_Facepaint.p3d);
    };
    class GVAR(BW_Facepaint): GVAR(US_Facepaint) {
        displayName = CSTRING(BW_FacePaint_DisplayName);
        descriptionShort = CSTRING(BW_FacePaint_descriptionShort);
        picture = QPATHTOF(data\UI\gear_BW_Facepaint.paa);
        model = QPATHTOF(data\BW_Facepaint.p3d);
    };
    // SnowStripes gets its own item (see GVAR(schemes) in cfr_common/functions/fnc_init.sqf)
    // rather than piggybacking on an existing one - reuses the BW model/icon as a placeholder, no
    // dedicated art yet
    class GVAR(SnowStripes_Facepaint): GVAR(US_Facepaint) {
        displayName = CSTRING(SnowStripes_Facepaint_DisplayName);
        descriptionShort = CSTRING(SnowStripes_Facepaint_descriptionShort);
        picture = QPATHTOF(data\UI\gear_BW_Facepaint.paa);
        model = QPATHTOF(data\BW_Facepaint.p3d);
    };
};
