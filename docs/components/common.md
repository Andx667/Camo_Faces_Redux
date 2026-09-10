# Common (`cfr_common`)

Functionality shared between addons — the core logic behind applying and removing camouflage, independent of the dialog UI.

## Key functions

| Function | Purpose |
| --- | --- |
| `fnc_init` | Builds the lists of base faces and camo-variant faces, and reapplies a unit's saved camo face on init |
| `fnc_getCountryOptions` | Returns which camo schemes (BW / Serbian / US) a unit can use, based on the facepaint items it's carrying |
| `fnc_getCamoOptions` | Returns the specific camo patterns available for a chosen scheme, for a unit's current base face |
| `fnc_setCamo` | Applies a chosen camo face to a unit and broadcasts it via a CBA global event |
| `fnc_unsetCamo` | Strips the camo suffix back off a unit's face, restoring the base face |

Applying and removing a face is synchronized across the network through a `cfr_common_setFace` CBA event (registered in `XEH_postInit.sqf`), rather than calling `setFace` directly — this keeps all clients' understanding of a unit's face in sync.
