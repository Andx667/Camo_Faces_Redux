# Dialog (`cfr_dialog`)

The graphical interface for choosing and applying camouflage. All textures used by the dialog were made by Sk3y and Feldhobel.

## Dependencies

- `cfr_main`
- `cfr_items`
- `cfr_faces`

## Flow

1. `fnc_canShowAction` gates an ACE self-action, **Camo Faces** (`CfgVehicles.hpp`), on the player having a compatible base/camo face and a facepaint item equipped.
2. `fnc_startDialog` opens the dialog (`GVAR(Dialog)`, `Dialog.hpp`); `fnc_initDialog` sets it up — checking equipped headgear/goggles/NV, populating the country listbox via `cfr_common`'s `fnc_getCountryOptions`, and starting a live mirror camera.
3. Selecting a country (`fnc_onLBCountryChanged`) populates the camo-pattern listbox via `cfr_common`'s `fnc_getCamoOptions`.
4. Selecting a camo pattern (`fnc_onLBCamoChanged`) unlocks the first "apply layer" button, once all headgear is removed.
5. `fnc_applyCamo` walks through the three layer buttons (each with a short delay via `CBA_fnc_waitAndExec`); the final layer calls into `cfr_common`'s `fnc_setCamo`.
6. `fnc_unsetCamo` (this addon) validates the current face before handing off to `cfr_common`'s `fnc_unsetCamo` to remove it.
7. `fnc_closeDialog` cleans up the mirror camera when the dialog closes (`onunload`).
8. `fnc_handleRespawn` (`Extended_Respawn_EventHandlers`) reapplies a unit's saved camo face after respawning.

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_canShowAction` | `[unit]` | Self-action condition: is the unit's face camo-able and does it have a facepaint item equipped? |
| `fnc_startDialog` | none | Opens the dialog |
| `fnc_closeDialog` | none | Deletes the mirror camera created by `fnc_initDialog` |
| `fnc_initDialog` | `[display]` | Sets initial dialog state: day/night textures, headgear/goggles/NV indicators, country listbox, mirror camera |
| `fnc_onLBCountryChanged` | `[listbox, index]` | Repopulates the camo-pattern listbox for the selected country/scheme |
| `fnc_onLBCamoChanged` | `[listbox, index]` | Unlocks the first "apply layer" button once headgear/goggles/NV are all off |
| `fnc_applyCamo` | `[level]` | Advances the 3-layer apply sequence; layer 3 actually calls `cfr_common`'s `fnc_setCamo` |
| `fnc_unsetCamo` | `[unit, face]` (both optional, default to the player/its current face) | Validates the current face, then removes camo via `cfr_common`'s `fnc_unsetCamo` |
| `fnc_handleRespawn` | `[unit]` | Reapplies a unit's saved camo face after it respawns |

## Dialog control IDs

Defined in `script_component.hpp` and used throughout `Dialog.hpp`/`functions/`, rather than as inline magic numbers:

| Macro | idc/idd | Control |
| --- | --- | --- |
| `IDD_DIALOG` | 311 | The dialog itself |
| `IDC_PICTURE_BOX` / `IDC_PICTURE_NOTEPAD` | 4961 / 4966 | Background box/notepad textures (day/night) |
| `IDC_TEXT_HELMET` / `IDC_PICTURE_HELMET` | 4862 / 4963 | Helmet indicator text/picture |
| `IDC_TEXT_GOGGLES` / `IDC_PICTURE_GOGGLES` | 4863 / 4964 | Goggles indicator text/picture |
| `IDC_TEXT_NV` / `IDC_PICTURE_NV` | 4864 / 4965 | NV goggles indicator text/picture |
| `IDC_RTT_MIRROR` | 4967 | The render-to-texture mirror surface |
| `IDC_LISTBOX_COUNTRY` / `IDC_LISTBOX_CAMOFACE` | 5262 / 5263 | Country and camo-pattern listboxes |
| `IDC_BUTTON_LAYER1` / `2` / `3` | 5362 / 5363 / 5364 | The three "apply layer" buttons |
| `IDC_BUTTON_UNCAMO` | 5365 | The "remove camo" button |
