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
| BW Facepaint | `cfr_items_BW_Facepaint` | Used by the German Armed Forces |
| Serbian Facepaint Sticks | `cfr_items_Serbian_Facepaint` | Used by the Serbian Armed Forces |
| US Facepaint Sticks | `cfr_items_US_Facepaint` | Used by the US Armed Forces |
| Box of Facepaint | `cfr_items_box` | A `Box_NATO_Support_F`-based supply crate stocked with 30 of each facepaint item above |

All three facepaint items are `ACE_ItemCore`-based (`CfgWeapons.hpp`), with `Serbian_Facepaint` and `BW_Facepaint` inheriting their `ItemInfo`/mass from `US_Facepaint`. `cfr_common`'s `fnc_getCountryOptions` checks a unit's `uniformItems` for these exact classnames to decide which camo schemes it can offer.

## Known issues / future work

- **`SERBIAN_Facepaint.p3d` still internally references `US_Facepaint`'s material.** Both LODs' faces point at `us_facepaint.rvmat` instead of the real `SERBIAN_Facepaint.rvmat` (added, but not yet wired up in the model), and LOD 1's faces still texture off `us_facepaint_co.paa` instead of `SERBIAN_Facepaint_co.paa`. In practice the item currently renders fine, so this fix is deferred rather than urgent — see `TODO-p3d.md` for the full technical write-up and the Object Builder steps needed (reassign both LODs' material/texture to the real Serbian ones).

## Credits

All models and textures were made by Sk3y and Feldhobel.
