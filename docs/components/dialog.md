# Dialog (`cfr_dialog`)

The graphical interface for applying camouflage.

All textures used by the dialog were made by Sk3y and Feldhobel.

A CBA setting ("Use ACE Actions Instead of Dialog") switches between two independent ways to reach the same `cfr_common` apply/remove logic below: this dialog, or a flat ACE self-action per camo scheme (plus a remove action) that skips the dialog entirely.

## Flow (dialog)

1. `fnc_canShowAction` gates an ACE self-action ("Camo Faces") on the player having a compatible base face and a facepaint item equipped.
2. `fnc_startDialog` opens the dialog; `fnc_initDialog` sets it up — checking equipped headgear/goggles/NV, populating the country listbox (BW / Serbian / US, plus Vanilla if available), and starting a live mirror camera.
3. Selecting a country (`fnc_onLBCountryChanged`) populates the camo-pattern listbox for that scheme.
4. Selecting a camo pattern (`fnc_onLBCamoChanged`) unlocks the first "apply layer" button, once all headgear is removed.
5. `fnc_applyCamo` walks through the three layer buttons, each with a short `CBA_fnc_waitAndExecute` delay (not an ACE progress bar — `ace_common_fnc_progressBar` unconditionally closes whatever dialog is currently open, which would close this one); the final layer calls into `cfr_common`'s `fnc_setCamo`.
6. `fnc_unsetCamo` (dialog) validates the current face before handing off to `cfr_common`'s `fnc_unsetCamo` to remove it.
7. `fnc_closeDialog` cleans up the mirror camera when the dialog is closed.
8. `fnc_handleRespawn` reapplies a unit's saved camo face after respawning.

## Flow (ACE actions)

1. `fnc_canApplyScheme` is each scheme action's condition — looks the scheme up directly in `cfr_common`'s `GVAR(schemes)`, so a scheme absent from that table (e.g. Vanilla without the Marksmen DLC) just doesn't show, no dialog involved.
2. `fnc_applyCamoAction` is the statement — it starts `fnc_applyCamoLayer` at layer 1, which recurses through 3 `ace_common_fnc_progressBar` bars (re-checking `fnc_canApplyScheme` each frame), then calls `cfr_common`'s `fnc_setCamo`.
3. `fnc_hasCamoApplied` gates the remove action, which reuses the dialog's own `fnc_unsetCamo`.
