# Dialog (`cfr_dialog`)

The graphical interface for choosing and applying camouflage. All textures used by the dialog were made by Sk3y and Feldhobel.

## Dependencies

- `cfr_main`
- `cfr_common`
- `cfr_items`
- `cfr_faces`

This addon offers two independent ways to reach the same underlying `cfr_common` apply/remove logic, toggled by a CBA setting (`GVAR(useAceActions)`, "Use ACE Actions Instead of Dialog"): the dialog UI below, or a flat tree of individual ACE self-actions (one per scheme, plus a remove action) that skips the dialog entirely. `GVAR(SelfAction)` and `GVAR(SelfActionRoot)` in `CfgVehicles.hpp` are mutually exclusive on that setting, so only one is ever visible.

## Flow (dialog)

1. `fnc_canShowAction` gates an ACE self-action, **Camo Faces** (`CfgVehicles.hpp`), on the player wearing a camo face (so camo can always be removed, even once the last stick is used up), or a compatible base face plus a facepaint item.
2. `fnc_startDialog` opens the dialog (`GVAR(Dialog)`, `Dialog.hpp`); `fnc_initDialog` sets it up — checking equipped headgear/goggles/NV, populating the country listbox via `cfr_common`'s `fnc_getCountryOptions` (the registered `CfgCamoCategories` - by default BW, Serbian, US, Snow Stripes and Vanilla - that the player's facepaint items and current face unlock), and starting a live mirror camera.
3. Selecting a country (`fnc_onLBCountryChanged`) populates the camo-pattern listbox via `cfr_common`'s `fnc_getCamoOptions`.
4. Selecting a camo pattern (`fnc_onLBCamoChanged`) unlocks the first "apply layer" button, once all headgear is removed.
5. `fnc_applyCamo` walks through the three layer buttons (each with a short delay via `CBA_fnc_waitAndExecute`); the final layer calls into `cfr_common`'s `fnc_setCamo`.
6. `fnc_unsetCamo` (this addon) validates the current face before handing off to `cfr_common`'s `fnc_unsetCamo` to remove it.
7. `fnc_closeDialog` cleans up the mirror camera when the dialog closes (`onunload`).

## Flow (ACE actions)

`GVAR(SelfActionRoot)` expands into one action per registered scheme plus the static `GVAR(Action_Remove)`, each independently gated and self-contained — no dialog, no country/pattern selection step. The per-scheme actions aren't listed in config: `fnc_getSchemeActions` (the root's `insertChildren`) builds one from every row of `cfr_common`'s `GVAR(schemes)` each time the menu opens, so schemes registered by other addons appear here automatically.

1. `fnc_canApplyScheme` is each scheme action's `condition`: looks up the scheme by id directly in `cfr_common`'s `GVAR(schemes)` and checks item/face/headgear preconditions in one pass. A scheme whose row isn't in `GVAR(schemes)` at all (e.g. Vanilla without Marksmen) is never built into the menu — no separate DLC check needed here.
2. `fnc_applyCamoAction` is the scheme action's `statement`: starts `fnc_applyCamoLayer` at layer 1, which recurses through 3 `ace_common_fnc_progressBar` bars (re-checking `fnc_canApplyScheme` on every frame, since no dialog is open to gate the buttons instead) before calling `cfr_common`'s `fnc_setCamo`.
3. **Animation:** `fnc_applyCamoLayer` starts the painter's animation at layer 1 (`fnc_startAnimation`) and ends it when the last bar finishes or any bar is cancelled (`fnc_stopAnimation`), so one move spans all three bars. `fnc_getAnimation` picks the move from `GVAR(animations)` (`XEH_preInit.sqf`), a table keyed `<who>_<weapon in hand>` - `self` (your own face) or `other` (buddy painting), and `rifle`, `pistol`, `launcher` or `none` - one entry per case, because a move from an armed animation set only suits its own weapon (a move from the unarmed set holsters whatever is carried and can be shared). An empty entry means no animation. Only buddy painting is wired up: it uses one unarmed move for every weapon, since it holsters whatever is carried (`InBaseMoves_assemblingVehicleErc`). The `self_*` entries are left empty until a fitting move is found, so applying camo to yourself doesn't animate. It only plays while standing (the moves start from a standing idle, so crouching and prone get none), never swimming, in a vehicle, in the air or while unconscious, and only if the move exists in the game's config. When painting someone else the painter turns to face them first. The moves are played with `ace_common_fnc_doAnimation` (global, so others see it) and ended by resetting to the default move for the stance and weapon. Buddy cleaning animates like buddy painting; the dialog flow doesn't animate.
4. `fnc_hasCamoApplied` is `Action_Remove`'s `condition` (only shows once something is actually applied); its `statement` reuses this addon's own `fnc_unsetCamo` directly, the same function the dialog's Uncamo button calls.

## Flow (buddy painting)

Players can paint or clean the face of a **friendly** unit standing next to them - player or AI, decided by `BIS_fnc_sideIsFriendly`, with no confirmation prompt - through the ACE interaction menu on that unit's **head** point. Two entries are added to ACE's own `ACE_Head` interaction point on `CAManBase` (`CfgVehicles.hpp`; `selection` "pilot", 1.5 m reach, the same point ACE medical puts its head treatments on) rather than to `ACE_MainActions`, which sits at the pelvis; the **Allow Painting Other Units** CBA setting (`GVAR(allowPaintingOthers)`, checkbox, default on, `isGlobal` 1 so it's mission rules, not a personal preference) switches both off.

1. **Paint Face** (`GVAR(BuddyPaint)`) is shown by `fnc_canPaintBuddy`: a valid target (`fnc_canTargetBuddy` - setting on, not yourself, alive, within `BUDDY_MAX_DISTANCE` (2.5 m), friendly), and at least one scheme that a facepaint item *you* carry unlocks and that has a variant for the target's face (the same test `fnc_getBuddyActions` uses for the children, so the entry never opens onto nothing). Its children come from `fnc_getBuddyActions`, built from `cfr_common`'s `GVAR(schemes)` when the menu opens (so other addons' schemes appear too): the schemes you carry an item for and that have a variant for the target's face. They stay visible but greyed out while `fnc_canApplyScheme` says no, which is how the painter learns the target still has headgear, goggles or night vision on - nobody can take another player's off.
2. Picking one runs the same three-bar sequence as the self-action (`fnc_applyCamoAction` -> `fnc_applyCamoLayer`), now carrying the target: `fnc_canApplyScheme` is re-checked every frame with the target, so walking away, the target putting headgear back on or dying cancels it. The last layer calls `cfr_common`'s `fnc_setCamo` on the *target*.
3. **Clean Face** (`GVAR(BuddyClean)`) is shown by `fnc_canCleanBuddy` (valid target and `fnc_hasCamoApplied`) and needs **no item**. `fnc_cleanBuddy` runs one 2 s progress bar, re-checking that condition, then calls `cfr_common`'s `fnc_unsetCamo` on the target. The cleaner plays the same animation as when painting a buddy for the length of the bar.

`fnc_setCamo`/`fnc_unsetCamo` only hint the machine's own player, so both flows tell the painter themselves and send a `cfr_dialog_notifyTarget` targeted event (`[stringKey, painterName]`) to the target's machine when the target is a player. Nothing else needed networking: the face change is the existing `cfr_common_setFace` global event, and the wear-off timer (players only) is started on the target's own machine by `fnc_setCamo`. Painted AI keep their camo until someone cleans it.

Painting spends one use of the *painter's* facepaint stick (see "Facepaint uses" below); cleaning costs nothing.

## Facepaint uses

The facepaint items are consumable sticks (see `cfr_items`): the dialog flow and both ACE flows spend exactly one use per successful application, at the very last step and just before `cfr_common`'s `fnc_setCamo`, through `cfr_common`'s `fnc_useFacepaint` (`fnc_applyCamo`'s third layer for the dialog, `fnc_applyCamoLayer`'s last layer for the ACE self-action and buddy painting). If that returns "no usable facepaint" (only possible if it vanished in the last frame - `fnc_canApplyScheme` re-checks it every frame of the bars) nothing is applied and the painter is told "No usable facepaint left" (not the unrelated "this face cannot be camouflaged"). Otherwise the painter is told how many uses are left, appended to the "applied" message, via `fnc_facepaintUsesText`. Every "does the player carry facepaint" check goes through `cfr_common`'s `fnc_hasFacepaint`, which counts a stick only while it has a use left and a legacy plain item always, anywhere in uniform, vest or backpack. `fnc_setCamo` never spends anything, which is what keeps Zeus, scripts and respawn/loadout restore free.

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_canShowAction` | `[unit]` | Self-action condition: is the unit wearing camo, or wearing a camo-able base face while carrying facepaint? |
| `fnc_startDialog` | none | Opens the dialog |
| `fnc_closeDialog` | none | Deletes the mirror camera created by `fnc_initDialog` |
| `fnc_initDialog` | `[display]` | Sets initial dialog state: day/night textures, headgear/goggles/NV indicators, country listbox, mirror camera |
| `fnc_onLBCountryChanged` | `[listbox, index]` | Repopulates the camo-pattern listbox for the selected country/scheme |
| `fnc_onLBCamoChanged` | `[listbox, index]` | Unlocks the first "apply layer" button once headgear/goggles/NV are all off |
| `fnc_applyCamo` | `[level]` | Advances the 3-layer apply sequence (dialog); layer 3 actually calls `cfr_common`'s `fnc_setCamo` |
| `fnc_getAnimation` | `[painter, target]` (target optional) | The move from `GVAR(animations)` for the situation, or `""` for none |
| `fnc_startAnimation` | `[painter, target]` (target optional) | Plays that move (turning to face the target first) and marks the painter as animating |
| `fnc_stopAnimation` | `[painter]` | Ends the move if one was started; otherwise does nothing |
| `fnc_unsetCamo` | `[unit, face]` (both optional, default to the player/its current face) | Validates the current face, then removes camo via `cfr_common`'s `fnc_unsetCamo` |
| `fnc_canApplyScheme` | `[schemeId, target]` (target optional, defaults to `ACE_player`) | ACE action condition for one scheme: your item, the target's face and headgear/goggles/NV, plus `fnc_canTargetBuddy` for someone else; read from `cfr_common`'s `GVAR(schemes)` |
| `fnc_applyCamoAction` | `[schemeId, target]` (target optional) | ACE action statement: starts the dialog-free 3-layer progress bar sequence at layer 1 |
| `fnc_applyCamoLayer` | `[schemeId, layer, target]` (target optional) | Runs one `ace_common_fnc_progressBar` for the given layer, then recurses into the next layer or calls `cfr_common`'s `fnc_setCamo` after layer 3 |
| `fnc_getSchemeActions` | `[target]` | ACE `insertChildren` for `SelfActionRoot`: one child action per scheme in `cfr_common`'s `GVAR(schemes)` |
| `fnc_canTargetBuddy` | `[target]` | May the player paint/clean this unit at all: setting on, alive, friendly, within reach, not themselves |
| `fnc_canPaintBuddy` | `[target]` | Condition of the **Paint Face** entry: valid target and at least one scheme that your facepaint unlocks and that covers the target's face |
| `fnc_canCleanBuddy` | `[target]` | Condition of the **Clean Face** entry: valid target that currently wears a camo face |
| `fnc_getBuddyActions` | `[target]` | ACE `insertChildren` for **Paint Face**: one child per scheme you can offer for the target's face |
| `fnc_cleanBuddy` | `[target]` | Runs the **Clean Face** progress bar, then removes the target's camo |
| `fnc_hasCamoApplied` | `[unit]` (optional, defaults to `ACE_player`) | ACE self-action condition for `Action_Remove`: does the unit currently have any camo face applied? |

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
