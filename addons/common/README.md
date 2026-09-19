# Common (`cfr_common`)

Core, UI-independent logic for applying and removing camouflage: building the lists of known faces, resolving which camo options are available to a unit, and actually changing (and networking) a unit's face. `cfr_dialog` is the only consumer of these functions, so the UI stays a thin layer over this shared logic.

## Dependencies

- `cfr_main`

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_init` | none | Builds `GVAR(all_faces)`/`GVAR(schemes)` (see below); called from `XEH_preInit` so this data exists before any mission entity - and therefore before any unit's init field - runs (`fnc_setCamo`/`fnc_unsetCamo` also self-defer a frame via `CBA_fnc_waitAndExecute` if called before this has run, as a safety net) |
| `fnc_getCountryOptions` | `[unit]` | Returns which camo schemes (BW / Serbian / US / Vanilla) a unit can use, based on which facepaint item(s) it's carrying |
| `fnc_getCamoOptions` | `[scheme]` | Returns the specific camo patterns available within a scheme, for the calling player's current base face |
| `fnc_setCamo` | `[unit, camo]` | Applies a camo face to a unit if the combination is valid, and hints the result; also schedules automatic wear-off if enabled (see Settings below) |
| `fnc_unsetCamo` | `[unit, face]` | Reverses whichever scheme the unit's current camo face belongs to, restoring its base face |
| `fnc_isCamoFace` | `[face]` | Checks whether a face classname is one of this mod's camo variants, under any scheme — shared predicate used by `fnc_setCamo`, `cfr_dialog`'s `fnc_canShowAction`, and both `fnc_unsetCamo` files |
| `fnc_getSchemeDisplayName` | `[schemeId]` | Returns a camo scheme's localized display name — used by `cfr_compat_zen`'s dynamic ZEN context menu |
| `fnc_handleRespawn` | `[unit]` | `Extended_Respawn_EventHandlers` hook - reapplies a unit's saved camo (if any) after it respawns, via `fnc_setCamo` |
| `fnc_startWearOff` | `[unit, face, camoId]` | Starts the wear-off timer on the unit's owner; raised by `fnc_setCamo` via the `cfr_common_startWearOff` targeted event |

## Settings

A CBA setting, **Camo Wear-off Time (Minutes)** (slider, 0 to 240, default 0), controls whether camo automatically fades back to the unit's original face after a set number of minutes - simulating real-world wear from rain, sweat, and time. 0 disables it (the default). Unlike `cfr_dialog`'s/`cfr_compat_zen`'s per-client UI toggles, this is registered with `isGlobal` 1 so every client shares the same value, since `fnc_setCamo` reads it locally when scheduling the timer.

Only player-controlled units get a timer - AI can't reapply camo by themselves, so it stays on for good. `fnc_setCamo` sends a `cfr_common_startWearOff` targeted event to the unit's owner, so the timer (`fnc_startWearOff`) runs on the machine that actually has the camo applied - a player's own client - rather than on whichever machine called `fnc_setCamo` (e.g. a Zeus). That also means the wear-off hint and `camoRemoved` event fire on the player's machine. The timer is a cancellable `CBA_fnc_addPerFrameHandler`, its ID stashed on the unit (`cfr_common_wearOffTimerId`). `fnc_unsetCamo` always cancels it first thing when it runs on the same machine. Camo can also be removed or reapplied from a different machine (e.g. a second Zeus), which can't reach this machine's timer, so each application gets a synced id (`cfr_common_camoId`, cleared on removal) and the timer stands down on its next tick if the unit's current id no longer matches its own - it can never clobber camo it didn't apply. A second timer also can't get stacked on top by re-applying: every scheme's pairs map from the same shared set of base faces, never from another scheme's camo face, so `fnc_setCamo` can't match a scheme for a unit already wearing camo and exits early - `fnc_unsetCamo` has to run first, which always cancels the existing timer. The applied scheme id is also stashed (`cfr_common_scheme`, cleared on removal) so respawn/JIP restore (`XEH_postInit.sqf`, `fnc_handleRespawn`) can just call `fnc_setCamo` again for units with active camo, getting a fresh timer along with the restored face rather than reapplying a face with no timer behind it.

## Networking

Applying or removing a face is synchronized across the network through a `cfr_common_setFace` CBA event (handler registered in `XEH_postInit.sqf`) rather than calling `setFace` directly — this keeps every client's view of a unit's face consistent, and avoids relying on banned commands (`spawn`, `execVM`, `remoteExec` — see `.hemtt/lints.toml`).

## Public API events

`fnc_setCamo`/`fnc_unsetCamo` raise two CBA events for other mods/missions to hook into, both only on a successful apply/removal (never on a rejected attempt), both via `CBA_fnc_localEvent` — i.e. only on the machine that actually ran `fnc_setCamo`/`fnc_unsetCamo` (typically whichever client is applying/removing its own camo), unlike the internal `cfr_common_setFace` event above, which is a `CBA_fnc_globalEvent` broadcast to every machine:

- `cfr_common_camoApplied` — `[unit, schemeId, oldFace, newFace]`, raised by `fnc_setCamo` after a camo face is applied
- `cfr_common_camoRemoved` — `[unit, schemeId, oldFace, newFace]`, raised by `fnc_unsetCamo` after a camo face is removed, restoring the base face

```sqf
[QGVAR(camoApplied), {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // ...
}] call CBA_fnc_addEventHandler;
```

`schemeId` matches the `schemeId` column of `GVAR(schemes)` below (e.g. `"BWTarn"`, `"Serbian"`, `"Vanilla"`).

## Global variables

`fnc_init` builds these once on mission start:

| Variable | Contents |
| --- | --- |
| `GVAR(all_faces)` | Every base face classname this mod knows how to camouflage |
| `GVAR(faces_noBlack)` | The base heads with no "Black" (night) camo variant in [`cfr_faces`](../faces/README.md) — the African and Tanoan heads plus Barklem, whose skin is dark enough that black paint reads as almost nothing |
| `GVAR(vanillaCamoFacePairs)` | `[baseFace, camoFace]` pairs for the vanilla, BI-authored camo faces from the Marksmen DLC (`CamoHead_<Race>_<NN>_F`) — one entry per base face, verified against Bohemia's own config |
| `GVAR(markCamoFaceSchemes)` | `[schemeId, pairs, stringKey]` rows for Marksmen's three environment-specific camo faces (arid / lush / semi-arid), which BI authored for only three base faces rather than one per face |
| `GVAR(schemes)` | The single source of truth every scheme consumer reads from — see below |

`GVAR(schemes)` is an array of `[schemeId, pairs, itemClasses, stringKey]` rows:

- `schemeId` — e.g. `"BWTarn"`, `"Vanilla"` — the string passed to `fnc_setCamo`/`fnc_canApplyScheme` and used as ACE action/dialog data
- `pairs` — `[[baseFace, camoFace], ...]`, which base face becomes which camo face under this scheme
- `itemClasses` — facepaint item classname(s) that unlock this scheme; always an array, even though most schemes only have one entry (`Black` and `Vanilla` accept any of the three, since Black is a pure color-shift not tied to a specific pattern)
- `stringKey` — this component's stringtable key suffix for the scheme's display name (e.g. `"camo_bwtarn"` → `STR_CFR_Common_camo_bwtarn`)

The 8 core schemes' `pairs` are *derived* from `GVAR(all_faces)` (via `FACES_CLASS_PREFIX`, defined in `script_component.hpp`) rather than hand-maintained separately, so they can't drift out of sync with the base face list. The vanilla rows are different: BI's vanilla camo classnames don't follow a suffix pattern (`CamoHead_White_01_F`, not `WhiteHead_01_something`), so their pairs come from explicit tables instead — and they are only appended to `GVAR(schemes)` at all if `isDLCAvailable 332350` (Marksmen) is true. Every consumer just reads `GVAR(schemes)`, so on a client without Marksmen they are completely and automatically absent everywhere (dialog country list, ACE actions, apply/remove) with no DLC-specific logic anywhere else in the mod.

There are four of those rows. `Vanilla` covers every base face, one `CamoHead_*` variant each. `VanillaArid`, `VanillaLush` and `VanillaSemiArid` are Marksmen's environment-specific faces, which BI authored for only three base faces — `PersianHead_A3_01`, `GreekHead_A3_02` and `WhiteHead_11`. They need a row each rather than one shared row because a scheme's `pairs` map a base face to exactly one camo face, so a single row can't offer one face three choices. Which base face each is painted over was determined by comparing the textures outside the painted area, not assumed.

Each unit's active camo face is also stored on the unit itself, via `_unit setVariable [QGVAR(face), <faceString>, true]`, so `XEH_postInit` (on mission start, after units exist - see `fnc_init.sqf`) and `cfr_dialog`'s `fnc_handleRespawn` (on respawn) can reapply it.

## CBA Extended Loadout

`XEH_postInit.sqf` also hooks CBA's Extended Loadout framework (`CBA_fnc_getLoadout`/`CBA_fnc_setLoadout`) so a unit's camo face rides along whenever something exports or imports a loadout through it (e.g. ACE Arsenal's loadout export, or a mission's own loadout persistence) - the unit-variable + reapply loop above only covers respawn/JIP on the *same* unit, not that round trip:

- `CBA_loadoutGet` — writes `GVAR(face)` into the `extendedInfo` hashMap if the unit has a camo face applied
- `CBA_loadoutSet` — reads it back and reapplies it via the same `cfr_common_setFace` networked event `fnc_setCamo`/`fnc_unsetCamo` use, rather than calling `setFace` directly

Both are `CBA_fnc_localEvent`s fired by CBA's `addons/loadout` component, only on whichever machine actually calls `CBA_fnc_getLoadout`/`CBA_fnc_setLoadout` — no `requiredAddons` entry is needed for this, since listening to a CBA event doesn't require the firing component to be explicitly declared.
