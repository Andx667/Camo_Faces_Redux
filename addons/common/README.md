# Common (`cfr_common`)

Core, UI-independent logic for applying and removing camouflage: building the lists of known faces, resolving which camo options are available to a unit, and actually changing (and networking) a unit's face. `cfr_dialog` is the only consumer of these functions, so the UI stays a thin layer over this shared logic.

## Dependencies

- `cfr_main`

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_init` | none | Builds `GVAR(all_faces)`/`GVAR(schemes)` (see below) and reapplies every unit's saved camo face on mission init |
| `fnc_getCountryOptions` | `[unit]` | Returns which camo schemes (BW / Serbian / US / Vanilla) a unit can use, based on which facepaint item(s) it's carrying |
| `fnc_getCamoOptions` | `[scheme]` | Returns the specific camo patterns available within a scheme, for the calling player's current base face |
| `fnc_setCamo` | `[unit, camo]` | Applies a camo face to a unit if the combination is valid, and hints the result |
| `fnc_unsetCamo` | `[unit, face]` | Reverses whichever scheme the unit's current camo face belongs to, restoring its base face |
| `fnc_isCamoFace` | `[face]` | Checks whether a face classname is one of this mod's camo variants, under any scheme — shared predicate used by `fnc_setCamo`, `cfr_dialog`'s `fnc_canShowAction`, and both `fnc_unsetCamo` files |

## Networking

Applying or removing a face is synchronized across the network through a `cfr_common_setFace` CBA event (handler registered in `XEH_postInit.sqf`) rather than calling `setFace` directly — this keeps every client's view of a unit's face consistent, and avoids relying on banned commands (`spawn`, `execVM`, `remoteExec` — see `.hemtt/lints.toml`).

## Public API events

`fnc_setCamo`/`fnc_unsetCamo` also broadcast two CBA events, `cfr_common_camoApplied`/`cfr_common_camoRemoved`, for other mods/missions to hook into — see [docs/api.md](../../docs/api.md) for the full reference. Both fire only on successful apply/removal (not on a rejected attempt), broadcast the same way as the internal `setFace` event (every machine, regardless of who triggered it), and share the same `[unit, schemeId, oldFace, newFace]` shape.

## Global variables

`fnc_init` builds these once on mission start:

| Variable | Contents |
| --- | --- |
| `GVAR(all_faces)` | Every base face classname this mod knows how to camouflage |
| `GVAR(faces_african)` | The base heads with no "Black" (night) camo variant in [`cfr_faces`](../faces/README.md) |
| `GVAR(vanillaCamoFacePairs)` | `[baseFace, camoFace]` pairs for the vanilla, BI-authored camo faces from the Marksmen DLC (`CamoHead_<Race>_<NN>_F`) — one entry per base face, verified against Bohemia's own config |
| `GVAR(schemes)` | The single source of truth every scheme consumer reads from — see below |

`GVAR(schemes)` is an array of `[schemeId, pairs, itemClasses, stringKey]` rows:

- `schemeId` — e.g. `"BWTarn"`, `"Vanilla"` — the string passed to `fnc_setCamo`/`fnc_canApplyScheme` and used as ACE action/dialog data
- `pairs` — `[[baseFace, camoFace], ...]`, which base face becomes which camo face under this scheme
- `itemClasses` — facepaint item classname(s) that unlock this scheme; always an array, even though every scheme but Vanilla only has one entry (Vanilla accepts any of the three)
- `stringKey` — this component's stringtable key suffix for the scheme's display name (e.g. `"camo_bwtarn"` → `STR_CFR_Common_camo_bwtarn`)

The 7 core schemes' `pairs` are *derived* from `GVAR(all_faces)` (via `FACES_CLASS_PREFIX`, defined in `script_component.hpp`) rather than hand-maintained separately, so they can't drift out of sync with the base face list. The `Vanilla` row is different: BI's vanilla camo classnames don't follow a suffix pattern (`CamoHead_White_01_F`, not `WhiteHead_01_something`), so its pairs come from the explicit `GVAR(vanillaCamoFacePairs)` table instead — and the row is only appended to `GVAR(schemes)` at all if `isDLCAvailable 332350` (Marksmen) is true. Every consumer just reads `GVAR(schemes)`, so on a client without Marksmen, `Vanilla` is completely and automatically absent everywhere (dialog country list, ACE actions, apply/remove) with no DLC-specific logic anywhere else in the mod.

Each unit's active camo face is also stored on the unit itself, via `_unit setVariable [QGVAR(face), <faceString>, true]`, so `fnc_init` (on mission start) and `cfr_dialog`'s `fnc_handleRespawn` (on respawn) can reapply it.
