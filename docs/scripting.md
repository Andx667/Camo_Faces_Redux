# Scripting & API

Mission makers and scripters can apply or remove camouflage directly from a script or the editor's init field, without going through the in-game dialog, ACE self-actions, or the Zeus context menu — and can react to camo being applied or removed by other means too. This page is the complete reference, including how addons can register their own faces and schemes; no repository access needed.

!!! warning "Don't build the classname yourself"
    Some camo face mods let you build the target face classname yourself (e.g. `(face this) + "_some_suffix"`) and call `setFace` directly. That doesn't work here — this mod's camo classnames aren't a simple suffix on the base face classname. A plain `setFace` call also only changes the face locally: it won't sync to other players or survive a respawn. Always go through the functions below instead.

## Applying camouflage

```sqf
[this, "BWTarn"] call cfr_common_fnc_setCamo;
```

| Argument | Type | Description |
| --- | --- | --- |
| 0 | `OBJECT` | The unit to camouflage |
| 1 | `STRING` | The camo scheme id — see [Scheme IDs](#scheme-ids) below |

This never uses up any facepaint - only applying camo through the dialog or the ACE actions does - and needs no item in the unit's inventory.

If the unit's current face doesn't have a variant under that scheme, nothing happens — no error. If the unit is the local player, they also get a hint explaining why; for any other unit (e.g. an AI) it fails silently.

If the **Camo Wear-off Time** CBA setting (see [Common](components/common.md)) is enabled, this also schedules automatic removal after the configured number of minutes — no extra argument needed, it just works the same as applying camo any other way. Only player-controlled units wear off; camo applied to an AI unit stays until removed, since AI can't reapply it themselves.

## Removing camouflage

```sqf
[this, face this] call cfr_common_fnc_unsetCamo;
```

| Argument | Type | Description |
| --- | --- | --- |
| 0 | `OBJECT` | The unit to remove camouflage from |
| 1 | `STRING` | The unit's current (camouflaged) face — usually just `face this` |

Restores whichever base face the given camo face pairs with.

## Scheme IDs

`"BWTarn"`, `"Black"`, `"BWStripes"`, `"Serbian"`, `"USStripes"`, `"USStains"`, `"USFlash"`, `"SnowStripes"`, or `"Vanilla"`, `"VanillaArid"`, `"VanillaLush"`, `"VanillaSemiArid"` (the Vanilla ones are only available with the Marksmen DLC — see [Installation](installation.md)).

Other addons can register further schemes and faces through config, which then work with every function on this page under their own ids — see [Extending the mod](#extending-the-mod) below for addon authors.

## Reacting to camo changes

Other mods/missions can hook into two CBA events, raised only on the machine that actually ran the apply or removal - the client calling the function for its own unit, the painter's machine when a player paints or cleans a teammate, or a Zeus's machine when using the Zeus menu. A camo that wears off fires `cfr_common_camoRemoved` on the wearer's own machine:

| Event | Payload | Raised by |
| --- | --- | --- |
| `cfr_common_camoApplied` | `[unit, schemeId, oldFace, newFace]` | `cfr_common_fnc_setCamo`, after a camo face is applied |
| `cfr_common_camoRemoved` | `[unit, schemeId, oldFace, newFace]` | `cfr_common_fnc_unsetCamo`, after a camo face is removed |

```sqf
["cfr_common_camoApplied", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // ...
}] call CBA_fnc_addEventHandler;
```

Neither event fires on a rejected attempt (e.g. no matching variant for that scheme).

## Extending the mod

Faces and schemes are registered entirely through config, so another addon can add either without touching this mod — and this mod's own faces ([Faces](components/faces.md)) are registered exactly the same way. Three config classes make up the registry (`CfgCamo.hpp` in the `cfr_common` addon defines this mod's own metadata and is the best reference):

- `CfgCamoBaseFaces` — one class per face that can be camouflaged, named after its `CfgFaces` class. Optional `requiredDLC = <Steam App ID>;` hides the face from anyone who doesn't own that DLC.
- `CfgCamoSchemes` — one class per scheme: `displayName` (a `$STR_` key or plain text), optional `shortName`, `icon`, `items[]` (facepaint items that unlock it), `categories[]` (which dialog categories list it), optional `requiredDLC`, and `class Faces { <baseFace> = "<camoFace>"; };` — the pairs. A scheme with no pair for a face is never offered for it.
- `CfgCamoCategories` — the dialog's first list: `displayName`, `items[]` (a category is offered when the unit carries one of them and at least one scheme in it is unlocked by an item the unit carries and covers the unit's face — schemes are gated by their own `items[]`, so a category and its schemes don't have to share the same items) and an optional `whiteBox = 1;` for the white-swatch paint box.

An `items[]` entry may be a magazine-type class (`CfgMagazines`, like this mod's facepaint sticks, where each round is a use) or a plain item (`CfgWeapons`, which is never used up).

### Give an existing scheme more faces

For example a face pack. Ship your own `CfgFaces` camo classes and textures, then:

```cpp
class CfgPatches {
    class my_camo_pack {
        requiredAddons[] = {"cfr_common"};   // so the registry classes exist to extend
        // ...
    };
};

class CfgCamoBaseFaces {
    class MyMod_Face_01 {};
};
class CfgCamoSchemes {
    class BWTarn {
        class Faces {
            MyMod_Face_01 = "mymod_Face_01_BWTarn";
        };
    };
};
```

### Add a whole new scheme

It appears in the dialog, the ACE self-actions and the ZEN menu with no other changes, as long as its `categories[]` names a category:

```cpp
class CfgCamoSchemes {
    class MyDesert {
        displayName = "Desert Stripes";
        icon = "\my_mod\data\icon_ca.paa";
        items[] = {"my_mod_Facepaint"};        // your own CfgWeapons item or CfgMagazines stick, or one of CFR's
        categories[] = {"my_category"};
        class Faces {
            GreekHead_A3_01 = "mymod_Greek01_Desert";
        };
    };
};
class CfgCamoCategories {
    class my_category {
        displayName = "My Camo";
        items[] = {"my_mod_Facepaint"};
    };
};
```

Your addon has to ship the camo faces themselves (`CfgFaces` classes with their textures) — registering only tells this mod which face maps to which. Nothing needs to be loaded before yours besides `cfr_common`; options are listed in config load order, so yours follow this mod's own.

Once registered, your scheme id works with every function on this page, e.g. `[this, "MyDesert"] call cfr_common_fnc_setCamo;`.
