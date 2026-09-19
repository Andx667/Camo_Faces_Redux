# Items (`cfr_items`)

Adds the inventory items needed to camouflage your face, and a supply box to distribute them.

## Dependencies

- `cfr_main`
- `A3_Weapons_F`
- `ace_common`
- `cba_common`

## Classes

| Item | Classname | Description |
| --- | --- | --- |
| BW Facepaint Stick | `cfr_items_BW_FacepaintStick` | Used by the German Armed Forces. 10 uses |
| Serbian Facepaint Stick | `cfr_items_Serbian_FacepaintStick` | Used by the Serbian Armed Forces. 10 uses |
| US Facepaint Stick | `cfr_items_US_FacepaintStick` | Used by the US Armed Forces. 10 uses |
| Snow Stripes Facepaint Stick | `cfr_items_SnowStripes_FacepaintStick` | White/green paint that unlocks the Snow Stripes scheme; reuses the BW model and icon as a placeholder. 10 uses |
| Box of Facepaint | `cfr_items_box` | A `Box_NATO_Support_F`-based supply crate stocked with 10 of each facepaint stick above |
| BW / Serbian / US / Snow Stripes Facepaint | `cfr_items_BW_Facepaint`, `cfr_items_Serbian_Facepaint`, `cfr_items_US_Facepaint`, `cfr_items_SnowStripes_Facepaint` | **Legacy** plain items, kept so existing missions and loadouts still work. They never run out and still unlock the same schemes, but are hidden from the arsenal and editor (`scope = 1`) |

## Consumable sticks

The sticks are `CfgMagazines` classes (`CfgMagazines.hpp`) with `count = 10`, marked `ACE_asItem = 1` so ACE's arsenal and inventory treat them as ordinary items - the same approach KAT Advanced Medical uses for its Penthrox inhaler. The magazine's remaining rounds *are* its uses, so partly used sticks survive loadouts, the arsenal, respawn and persistence with no extra code. Applying camo through the dialog or an ACE action (self or buddy painting, see `cfr_dialog`) spends one use of the painter's stick through `cfr_common`'s `fnc_useFacepaint`, which uses ACE's own `ace_common_fnc_adjustMagazineAmmo`: it finishes the most-used stick first and removes a stick once it is empty. The stick can be carried anywhere - uniform, vest or backpack. Cleaning a face costs nothing, and neither do Zeus, scripts (`fnc_setCamo`) or respawn/loadout restore.

The legacy items are `ACE_ItemCore`-based (`CfgWeapons.hpp`), with `Serbian_Facepaint`, `BW_Facepaint` and `SnowStripes_Facepaint` inheriting their `ItemInfo`/mass from `US_Facepaint`.

Which item unlocks which scheme is not decided here: each scheme lists its unlocking items in `cfr_common`'s `CfgCamoSchemes` registry (`items[]`) - both the stick and the legacy item - and other addons can add their own items the same way. A magazine-type entry is used up, a plain-item entry is not.

## Known issues / future work

- **`SERBIAN_Facepaint.p3d` still internally references `US_Facepaint`'s material.** Both LODs' faces point at `us_facepaint.rvmat` instead of the real `SERBIAN_Facepaint.rvmat` (added, but not yet wired up in the model), and LOD 1's faces still texture off `us_facepaint_co.paa` instead of `SERBIAN_Facepaint_co.paa`. In practice the item currently renders fine, so this fix is deferred rather than urgent — see `TODO-p3d.md` for the full technical write-up and the Object Builder steps needed (reassign both LODs' material/texture to the real Serbian ones).

## Credits

All models and textures were made by Sk3y and Feldhobel.
