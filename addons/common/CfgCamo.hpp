// Registry of camouflage the rest of the mod - and any other addon - can extend purely through
// config. Read once at preInit by fnc_init.sqf into GVAR(all_faces)/GVAR(schemes)/GVAR(categories),
// which every consumer (dialog, ACE self-actions, ZEN menu) then reads; nothing else lists schemes.
// See README.md ("Extending the mod") for how another addon adds a face or a whole new scheme.
//
// This file defines the *metadata*. Which faces each scheme applies to (class Faces) is added by
// cfr_faces, through exactly the same config extension any other addon would use.

// What the dialog's first list shows. A category is offered when the unit carries one of its items
// AND at least one of its schemes is unlocked by an item the unit carries (each scheme's own items[])
// and has a variant for the unit's current face.
class CfgCamoCategories {
    class bw {
        displayName = ECSTRING(items,bw_facepaint_displayname);
        items[] = {QEGVAR(items,BW_FacepaintStick), QEGVAR(items,BW_Facepaint)};
    };
    class serbian {
        displayName = ECSTRING(items,serbian_facepaint_displayname);
        items[] = {QEGVAR(items,Serbian_FacepaintStick), QEGVAR(items,Serbian_Facepaint)};
    };
    class us {
        displayName = ECSTRING(items,us_facepaint_displayname);
        items[] = {QEGVAR(items,US_FacepaintStick), QEGVAR(items,US_Facepaint)};
    };
    // whiteBox: the dialog shows the white-swatch paint box instead of the shared brown one
    class snow {
        displayName = ECSTRING(items,snowstripes_facepaint_displayname);
        items[] = {QEGVAR(items,SnowStripes_FacepaintStick), QEGVAR(items,SnowStripes_Facepaint)};
        whiteBox = 1;
    };
    // not tied to one item - any of the three facepaints unlocks it
    class vanilla {
        displayName = CSTRING(camo_vanilla);
        items[] = ALL_FACEPAINT_ITEMS;
    };
};

// Faces that can be camouflaged. Each entry is a class named after the CfgFaces class of the plain,
// un-camo'd face. Added by cfr_faces (and any addon shipping its own camo faces); requiredDLC is a
// Steam App ID checked with isDLCAvailable at preInit, so a base face whose DLC isn't owned simply
// isn't registered anywhere. Omit it (or 0) for faces that are always available.
class CfgCamoBaseFaces {};

// The schemes themselves:
//   displayName  - shown in the ACE self-actions and the ZEN menu
//   shortName    - optional shorter label for the dialog's narrow pattern list (defaults to displayName)
//   icon         - ACE self-action icon (defaults to the generic camo icon)
//   items[]      - facepaint items that unlock the scheme (carrying any one is enough). A magazine-type
//                  class (CfgMagazines, like cfr_items' facepaint sticks) is used up - one round per
//                  application - while a plain item (CfgWeapons) is not
//   categories[] - CfgCamoCategories entries the dialog lists it under
//   requiredDLC  - Steam App ID that must be owned for the scheme to exist at all (0 = none)
//   class Faces  - "<base face> = <camo face>;" pairs. A scheme without a pair for a face is never
//                  offered for it, which is how e.g. Black skips faces where black paint is invisible
// The order here is the order options are listed in.
class CfgCamoSchemes {
    class BWTarn {
        displayName = CSTRING(camo_bwtarn);
        icon = QPATHTOF(data\UI\Icon_bwtarn_ca.paa);
        items[] = {QEGVAR(items,BW_FacepaintStick), QEGVAR(items,BW_Facepaint)};
        categories[] = {"bw"};
    };
    class BWStripes {
        displayName = CSTRING(camo_bwstripes);
        icon = QPATHTOF(data\UI\Icon_bwstripes_ca.paa);
        items[] = {QEGVAR(items,BW_FacepaintStick), QEGVAR(items,BW_Facepaint)};
        categories[] = {"bw"};
    };
    // a pure colour shift, not tied to a pattern - any facepaint unlocks it, under every military category
    class Black {
        displayName = CSTRING(camo_black);
        icon = QPATHTOF(data\UI\Icon_black_ca.paa);
        items[] = ALL_FACEPAINT_ITEMS;
        categories[] = {"bw", "serbian", "us"};
    };
    class Serbian {
        displayName = CSTRING(camo_serbian);
        shortName = CSTRING(camo_serbian_short);
        icon = QPATHTOF(data\UI\Icon_serbian_ca.paa);
        items[] = {QEGVAR(items,Serbian_FacepaintStick), QEGVAR(items,Serbian_Facepaint)};
        categories[] = {"serbian"};
    };
    class USStripes {
        displayName = CSTRING(camo_usstripes);
        icon = QPATHTOF(data\UI\Icon_usstripes_ca.paa);
        items[] = {QEGVAR(items,US_FacepaintStick), QEGVAR(items,US_Facepaint)};
        categories[] = {"us"};
    };
    class USStains {
        displayName = CSTRING(camo_usstains);
        icon = QPATHTOF(data\UI\Icon_usstains_ca.paa);
        items[] = {QEGVAR(items,US_FacepaintStick), QEGVAR(items,US_Facepaint)};
        categories[] = {"us"};
    };
    class USFlash {
        displayName = CSTRING(camo_usflash);
        icon = QPATHTOF(data\UI\Icon_usflash_ca.paa);
        items[] = {QEGVAR(items,US_FacepaintStick), QEGVAR(items,US_Facepaint)};
        categories[] = {"us"};
    };
    // own item and own category; reuses the Black icon as a placeholder, no dedicated icon yet
    class SnowStripes {
        displayName = CSTRING(camo_snowstripes);
        icon = QPATHTOF(data\UI\Icon_black_ca.paa);
        items[] = {QEGVAR(items,SnowStripes_FacepaintStick), QEGVAR(items,SnowStripes_Facepaint)};
        categories[] = {"snow"};
    };
    // Bohemia's own Marksmen DLC camo faces (332350) - see cfr_faces for the pairs. A CamoHead_*
    // face keeps the plain face texture and gets its camo from a shared mask in the material, whereas
    // the three environment variants below have camo baked into their own textures and exist for
    // only three base faces. Four distinct looks, so four schemes: a scheme maps a base face to
    // exactly one camo face, so one base face can't offer several choices within a single scheme.
    class Vanilla {
        displayName = CSTRING(camo_vanilla);
        shortName = CSTRING(camo_vanilla_short);
        icon = QPATHTOF(data\UI\Icon_camoon_ca.paa);
        items[] = ALL_FACEPAINT_ITEMS;
        categories[] = {"vanilla"};
        requiredDLC = 332350;
    };
    // The three variants are written out in full rather than inheriting from Vanilla, since a
    // subclass would inherit class Faces as well.
    class VanillaArid {
        displayName = CSTRING(camo_vanilla_arid);
        shortName = CSTRING(camo_vanilla_arid_short);
        icon = QPATHTOF(data\UI\Icon_camoon_ca.paa);
        items[] = ALL_FACEPAINT_ITEMS;
        categories[] = {"vanilla"};
        requiredDLC = 332350;
    };
    class VanillaLush {
        displayName = CSTRING(camo_vanilla_lush);
        shortName = CSTRING(camo_vanilla_lush_short);
        icon = QPATHTOF(data\UI\Icon_camoon_ca.paa);
        items[] = ALL_FACEPAINT_ITEMS;
        categories[] = {"vanilla"};
        requiredDLC = 332350;
    };
    class VanillaSemiArid {
        displayName = CSTRING(camo_vanilla_semiarid);
        shortName = CSTRING(camo_vanilla_semiarid_short);
        icon = QPATHTOF(data\UI\Icon_camoon_ca.paa);
        items[] = ALL_FACEPAINT_ITEMS;
        categories[] = {"vanilla"};
        requiredDLC = 332350;
    };
};
