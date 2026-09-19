class CfgVehicles {
    class Box_NATO_Support_F;
    class GVAR(box): Box_NATO_Support_F {
        scope = 2;
        displayName = CSTRING(box_displayName);
        author = AUTHOR;
        editorSubcategory = QEGVAR(main,cfr);

        class TransportWeapons {};
        // facepaint sticks, 10 uses each - not the unlimited legacy items
        class TransportMagazines {
            MACRO_ADDMAGAZINE(GVAR(US_FacepaintStick),10);
            MACRO_ADDMAGAZINE(GVAR(BW_FacepaintStick),10);
            MACRO_ADDMAGAZINE(GVAR(Serbian_FacepaintStick),10);
            MACRO_ADDMAGAZINE(GVAR(SnowStripes_FacepaintStick),10);
        };
        class TransportItems {};
    };
};
