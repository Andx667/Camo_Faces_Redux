// The consumable facepaint: each stick is a magazine whose rounds are its uses (the same trick KAT
// Advanced Medical's Penthrox inhaler uses), so 10 rounds = 10 applications. ACE_asItem makes ACE's
// arsenal and inventory treat it as an ordinary item rather than ammunition; ACE's own
// adjustMagazineAmmo spends a use and deletes the stick once it is empty (see cfr_common's
// fnc_useFacepaint). The CfgWeapons facepaint items are kept as unlimited legacy versions.
class CfgMagazines {
    class CA_Magazine;

    class GVAR(US_FacepaintStick): CA_Magazine {
        author = AUTHOR;
        scope = 2;
        displayName = CSTRING(US_FacepaintStick_DisplayName);
        descriptionShort = CSTRING(US_FacepaintStick_descriptionShort);
        picture = QPATHTOF(data\UI\gear_US_Facepaint.paa);
        model = QPATHTOF(data\US_Facepaint.p3d);

        ammo = "";
        count = 10;
        initSpeed = 0;
        tracersEvery = 0;
        lastRoundsTracer = 0;
        mass = 1;
        ACE_asItem = 1;
    };
    class GVAR(Serbian_FacepaintStick): GVAR(US_FacepaintStick) {
        displayName = CSTRING(Serbian_FacepaintStick_DisplayName);
        descriptionShort = CSTRING(Serbian_FacepaintStick_descriptionShort);
        picture = QPATHTOF(data\UI\gear_SERBIAN_Facepaint.paa);
        model = QPATHTOF(data\SERBIAN_Facepaint.p3d);
    };
    class GVAR(BW_FacepaintStick): GVAR(US_FacepaintStick) {
        displayName = CSTRING(BW_FacepaintStick_DisplayName);
        descriptionShort = CSTRING(BW_FacepaintStick_descriptionShort);
        picture = QPATHTOF(data\UI\gear_BW_Facepaint.paa);
        model = QPATHTOF(data\BW_Facepaint.p3d);
    };
    // reuses the BW model/icon as a placeholder, like the SnowStripes_Facepaint item it replaces
    class GVAR(SnowStripes_FacepaintStick): GVAR(US_FacepaintStick) {
        displayName = CSTRING(SnowStripes_FacepaintStick_DisplayName);
        descriptionShort = CSTRING(SnowStripes_FacepaintStick_descriptionShort);
        picture = QPATHTOF(data\UI\gear_BW_Facepaint.paa);
        model = QPATHTOF(data\BW_Facepaint.p3d);
    };
};
