# Usage

## Applying camouflage

1. Equip one of the facepaint items (BW, Serbian, or US Facepaint) in your uniform. These are stocked in the **Box of Facepaint** placed by mission makers, or can be added to a loadout directly.
2. Remove your helmet, goggles, and night vision — camouflage can only be applied to a bare face.
3. Open your ACE self-interaction menu and select **Camo Faces** to open the camouflage dialog.
4. Pick a country/scheme from the left list, then a specific camo pattern from the right list.
5. Click the three layer buttons in order to build up the camouflage. Each layer has a short delay before the next one unlocks; the final layer applies the chosen face.

## Removing camouflage

Open the dialog again (the self-action also shows while camo is currently applied) and use the **remove camo** button to revert to your original face.

## Notes

- The dialog shows a live mirror preview of your face while it's open.
- Your applied camo face is remembered per-unit and reapplied automatically on respawn.

## As Zeus (optional)

If [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) is also loaded, right-clicking a unit brings up a **Camouflage** entry in the context menu — see [Zeus Enhanced Compat](components/compat_zen.md).

## From script / init field

Some camo face mods let you build the target face classname yourself, e.g. `(face this) + "_some_suffix"`, then call `setFace` directly. That pattern doesn't work here: this mod's camo classnames aren't a simple suffix on the base face classname, and a plain `setFace` call only changes the face locally — it won't sync to other players or survive a respawn. Instead, call this mod's own function, which resolves the correct classname and handles both of those for you:

```sqf
// apply a scheme to this unit
[this, "BWTarn"] call cfr_common_fnc_setCamo;

// remove it again, restoring this unit's original face
[this, face this] call cfr_common_fnc_unsetCamo;
```

The scheme id (`"BWTarn"` above) is one of `"BWTarn"`, `"Black"`, `"BWStripes"`, `"Serbian"`, `"USStripes"`, `"USStains"`, `"USFlash"`, or `"Vanilla"` (only available with the Marksmen DLC). If the unit's current face doesn't have a variant under that scheme, nothing happens — no error, just a hint explaining why.

Other mods/missions can also react to camo being applied or removed via two CBA events, `cfr_common_camoApplied`/`cfr_common_camoRemoved` — see [`cfr_common`'s README](https://github.com/Andx667/CamoFacesRedux/blob/main/addons/common/README.md) for the full reference.
