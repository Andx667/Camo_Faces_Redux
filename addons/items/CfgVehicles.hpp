class CfgVehicles {
    class Box_NATO_Support_F;
    class GVAR(box): Box_NATO_Support_F {
        scope = 2;
        displayName = CSTRING(box_displayName);
        author = AUTHOR;
        editorSubcategory = QEGVAR(main,cfr);

        class TransportWeapons {};
        class TransportMagazines {};
        class TransportItems {
            MACRO_ADDITEM(GVAR(US_Facepaint),30);
            MACRO_ADDITEM(GVAR(BW_Facepaint),30);
            MACRO_ADDITEM(GVAR(SERBIAN_Facepaint),30);
            MACRO_ADDITEM(GVAR(SnowStripes_Facepaint),30);
        };
    };
};
