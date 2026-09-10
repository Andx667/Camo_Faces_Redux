# Common (`cfr_common`)

Core, UI-independent logic for applying and removing camouflage: building the lists of known faces, resolving which camo options are available to a unit, and actually changing (and networking) a unit's face. `cfr_dialog` is the only consumer of these functions, so the UI stays a thin layer over this shared logic.

## Dependencies

- `cfr_main`

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_init` | none | Builds the `GVAR(all_faces)`/`GVAR(faces_*)` lookup lists (see below) and reapplies every unit's saved camo face on mission init |
| `fnc_getCountryOptions` | `[unit]` | Returns which camo schemes (BW / Serbian / US) a unit can use, based on which facepaint item(s) it's carrying |
| `fnc_getCamoOptions` | `[scheme]` | Returns the specific camo patterns available within a scheme, for the calling player's current base face |
| `fnc_setCamo` | `[unit, camo]` | Applies a camo face to a unit if the combination is valid, and hints the result |
| `fnc_unsetCamo` | `[unit, face]` | Strips the camo suffix back off a unit's face, restoring its base face |

## Networking

Applying or removing a face is synchronized across the network through a `cfr_common_setFace` CBA event (handler registered in `XEH_postInit.sqf`) rather than calling `setFace` directly — this keeps every client's view of a unit's face consistent, and avoids relying on banned commands (`spawn`, `execVM`, `remoteExec` — see `.hemtt/lints.toml`).

## Global variables

`fnc_init` builds these once on mission start:

| Variable | Contents |
| --- | --- |
| `GVAR(all_faces)` | Every base face classname this mod knows how to camouflage |
| `GVAR(faces_african)` | The base heads with no "Black" (night) camo variant in [`cfr_faces`](../faces/README.md) |
| `GVAR(faces_bwtarn)`, `faces_black`, `faces_bwstripes`, `faces_serbian`, `faces_usstripes`, `faces_usstains`, `faces_usflash` | Per-scheme lists of real `cfr_faces` `CfgFaces` classnames (`cfr_faces_<BaseFace>_<Scheme>`) recognized as valid, already-camouflaged faces |

The `faces_*` lists are *derived* from `GVAR(all_faces)` (via `FACES_CLASS_PREFIX`, defined in `script_component.hpp`) rather than hardcoded separately, so they can't drift out of sync with each other the way a second hand-maintained copy could.

Each unit's active camo face is also stored on the unit itself, via `_unit setVariable [QGVAR(face), <faceString>, true]`, so `fnc_init` (on mission start) and `cfr_dialog`'s `fnc_handleRespawn` (on respawn) can reapply it.
