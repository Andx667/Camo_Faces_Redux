# Dialog (`cfr_dialog`)

The graphical interface for applying camouflage.

All textures used by the dialog were made by Sk3y and Feldhobel.

## Flow

1. `fnc_canShowAction` gates an ACE self-action ("Camo Faces") on the player having a compatible base face and a facepaint item equipped.
2. `fnc_startDialog` opens the dialog; `fnc_initDialog` sets it up — checking equipped headgear/goggles/NV, populating the country listbox, and starting a live mirror camera.
3. Selecting a country (`fnc_onLBCountryChanged`) populates the camo-pattern listbox for that scheme.
4. Selecting a camo pattern (`fnc_onLBCamoChanged`) unlocks the first "apply layer" button, once all headgear is removed.
5. `fnc_applyCamo` walks through the three layer buttons; the final layer calls into `cfr_common`'s `fnc_setCamo`.
6. `fnc_unsetCamo` (dialog) validates the current face before handing off to `cfr_common`'s `fnc_unsetCamo` to remove it.
7. `fnc_closeDialog` cleans up the mirror camera when the dialog is closed.
8. `fnc_handleRespawn` reapplies a unit's saved camo face after respawning.
