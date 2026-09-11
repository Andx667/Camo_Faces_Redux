# Common (`cfr_common`)

Functionality shared between addons — the core logic behind applying and removing camouflage, independent of the dialog UI.

## Key functions

| Function | Purpose |
| --- | --- |
| `fnc_init` | Builds `GVAR(all_faces)` and `GVAR(schemes)` (base ↔ camo face pairs per scheme, including a conditional vanilla DLC scheme), and reapplies a unit's saved camo face on init |
| `fnc_getCountryOptions` | Returns which camo schemes (BW / Serbian / US / Vanilla) a unit can use, based on the facepaint items it's carrying |
| `fnc_getCamoOptions` | Returns the specific camo patterns available for a chosen scheme, for a unit's current base face |
| `fnc_setCamo` | Applies a chosen camo face to a unit and broadcasts it via a CBA global event |
| `fnc_unsetCamo` | Reverses whichever scheme the unit's current camo face belongs to, restoring the base face |
| `fnc_isCamoFace` | Checks whether a face is one of this mod's camo variants, under any scheme |

`GVAR(schemes)` is a data table, not per-scheme hardcoded logic — every function above reads from it rather than branching on scheme name. The "Vanilla" scheme (BI's own Marksmen DLC camo faces) is appended to it only if `isDLCAvailable 332350` is true, so it's automatically absent everywhere for players without that DLC.

Applying and removing a face is synchronized across the network through a `cfr_common_setFace` CBA event (registered in `XEH_postInit.sqf`), rather than calling `setFace` directly — this keeps all clients' understanding of a unit's face in sync.
