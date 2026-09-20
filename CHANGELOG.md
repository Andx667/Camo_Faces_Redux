# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Translations for every language Arma 3 ships, on top of English and German: Czech, French, Spanish, Latin, Italian, Polish, Portuguese, Russian, Ukrainian, Bulgarian, Slovak, Hungarian, Turkish, Korean, Japanese, Traditional Chinese and Simplified Chinese. This covers every setting, menu entry, message and item name, and all 667 camo face names (which use the game's own spelling of each head's surname). The translations were written by an AI assistant rather than native speakers, so corrections are welcome
- `tools/camo_generator/generate_languages.py` and `i18n.py`, which give new faces a name in every language, and `data/names_i18n.json` with each head's surname in every language
- Consumable facepaint: the BW, Serbian, US and Snow Stripes facepaint are now sticks with 10 uses each (`cfr_items_*_FacepaintStick`, modelled on KAT Advanced Medical's Penthrox inhaler). Applying camo through the dialog or the ACE actions - your own face or a teammate's - spends one use of the painter's stick, you're told how many are left, and the stick is removed when it is empty. Sticks can be carried anywhere in the uniform, vest or backpack. Cleaning a face is free, and so is anything done by a Zeus or a script (`cfr_common_fnc_setCamo`)
- Camo washes off in water: a player who dives underwater loses their camouflage and gets their original face back. Swimming on the surface does not wash it off, and AI keep their camo. New CBA setting **Will Camo Wash Off in Water** (on by default, shared by all clients) turns it off, for example for naval missions

### Changed

- The Box of Facepaint now holds 10 of each facepaint stick instead of 30 of each plain item
- The original plain facepaint items (`cfr_items_BW_Facepaint`, `cfr_items_Serbian_Facepaint`, `cfr_items_US_Facepaint`, `cfr_items_SnowStripes_Facepaint`) still work and never run out, so existing missions and loadouts are unaffected, but they are hidden from the arsenal and editor. Facepaint is now recognised in the vest and backpack as well as the uniform
- A scheme's or category's `items[]` may list either kind of item: a magazine-type entry is used up, a plain-item entry is not
- The addon-author guide "Extending the mod" moved from `cfr_common`'s README to the Scripting & API page of the documentation site

### Fixed

- Camo could not be removed once the last use of the facepaint stick was spent: the stick is removed when empty, and the "Camo Faces" self-action (and its Remove entry) only showed while you carried facepaint. It now always shows while you are wearing camo
- The unused `STR_CFR_Main_Name` string still carried the "[Beta]" tag dropped from the mod's name in 1.0.0

## [2.0.0] - 2026-09-19

### Added

- Buddy painting: players can paint camouflage on, or clean it off, the face of a friendly unit (player or AI) standing next to them, through the ACE interaction menu on that unit's head. Painting needs facepaint in the painter's uniform and the target's helmet, goggles and night vision off; cleaning needs nothing. New CBA setting **Allow Painting Other Units** (on by default, shared by all clients) turns it off. Painting doesn't use up any facepaint yet
- Other addons can now add camouflage faces and whole new schemes purely through config (`CfgCamoBaseFaces`, `CfgCamoSchemes`, `CfgCamoCategories`), and they show up in the dialog, the ACE self-actions and the Zeus menu with no changes to this mod. The mod's own faces and schemes are registered through the same mechanism. See "Extending the mod" in `cfr_common`'s README
- Each camo application's wear-off duration is now randomised with the configured **Camo Wear-off Time** as the most likely value, typically within about 10 minutes either side, so players who applied camo together don't all lose it at the same moment. The spread is fixed rather than a setting, and a duration is never shorter than a minute
- A hint warns the wearer a minute before their camouflage wears off, since the randomised wear-off time can't be predicted from the setting

### Changed

- **Breaking for scripters and addon authors:** everything that lists camo schemes (face lists, DLC gates, dialog categories, ACE self-actions) is now read from the config registry instead of being hardcoded in several places. `cfr_common`'s internal data changed shape as a result: `GVAR(schemes)` rows are now `[schemeId, pairs, itemClasses, displayName, shortName, icon, categories]` (the fourth entry is an already-localized name, no longer a stringtable key), and `GVAR(faces_noBlack)`, `GVAR(vanillaCamoFacePairs)` and `GVAR(markCamoFaceSchemes)` are gone. The public functions and the `cfr_common_camoApplied`/`cfr_common_camoRemoved` events are unchanged. The per-scheme ACE self-actions are built when the menu opens rather than declared one by one, so the `cfr_dialog_Action_<Scheme>` classes no longer exist in config
- The wear-off timer now runs on the machine that owns the unit rather than on whichever machine applied the camo, so a Zeus applying camo to a player no longer leaves the timer on the curator's machine (where it would die with them). As a result the "camouflage removed" hint and `cfr_common_camoRemoved` fire on the wearer's machine. AI units no longer wear off - they can't reapply camo themselves, so wearing it off would only strip it for good; camo on an AI unit stays until it is cleaned or removed

### Fixed

- Camo removed or reapplied from another machine (for example by a second Zeus) is no longer stripped early by a stale wear-off timer left over from an earlier application
- The Snow Stripes facepaint alone now shows the camo action when carried; it was previously missing from the list of items that unlock the menu entry
- The README, Steam Workshop description and documentation site feature lists were out of date: they now cover Snow Stripes and its facepaint item, the DLC faces, the Marksmen camo faces, wear-off, buddy painting and the extension mechanism

## [1.0.0] - 2026-09-18

### Added

- Camouflage for 46 faces added by later DLCs, bringing the total from 39 to 85: Apex (the nine Tanoan heads and Asian 04-07), Contact (the Livonian and Russian heads, plus White 24-32), Laws of War (Greek 11-14 and White 23), Tac-Ops Mission Pack (Barklem, Mavros and Sturrock) and Tanks (Ioannou). Most only appear for players who actually own the relevant DLC, the same way the Vanilla scheme already does for Marksmen owners - Barklem, Mavros, Sturrock and Ioannou are the exception: they're named campaign personas, but their faces are ordinary, non-disabled heads that any mission can put a unit in regardless of who owns the DLC, so camo for them isn't optional to skip. Night isn't offered on the African, Tanoan or Barklem heads, whose skin is dark enough that black paint reads as almost nothing. This roughly triples the mod's install size (textures alone grow from ~115 MB to ~310 MB)
- Marksmen's three environment-specific camo faces — arid, lush and semi-arid — are now selectable alongside the renamed "Vanilla Camouflage (Standard)" scheme. Bohemia authored these for only three faces, so they are offered to `PersianHead_A3_01`, `GreekHead_A3_02` and `WhiteHead_11` and hidden for everyone else
- Configurable camo wear-off timer: a CBA setting (slider, 0 to 240 minutes, default 0/disabled) that automatically restores a unit's original face a set number of minutes after camo is applied, simulating it fading from rain, sweat, or time
- Camo face now travels with a unit's loadout through CBA's Extended Loadout framework (`CBA_fnc_getLoadout`/`CBA_fnc_setLoadout`), so it survives round trips like ACE Arsenal's loadout export/import or a mission's own loadout persistence — previously only respawn/JIP reapplication on the same unit was covered

### Changed

- First stable release: dropped the "[Beta]" tag from the mod's display name and the beta disclaimer from the Steam Workshop description

### Fixed

- A merge had left the CBA setting category variable (`_category`) commented out, which threw an undefined-variable error during `preInit` and broke the mod's initialization, and had misnamed the dialog's listbox base class `RscListbox` instead of the engine's `RscListBox`, breaking the country and camo-face list boxes
- Snow Stripes listed in the camo scheme table in the faces component documentation, which had been missing it

## [0.9.4] - 2026-09-14

### Added

- SnowStripes camo scheme (green base with white diagonal stripes), replacing an unreleased EyeBlack prototype. Like the other schemes, it gets its own dedicated facepaint item and a top-level category in the dialog

### Fixed

- Applying or removing camo on a unit other than the local player (e.g. scripted onto AI from a unit's init field) incorrectly popped the "camo applied"/"camo removed" hint on the local player's own screen
- A unit's camo could occasionally fail as "invalid face" if something called `fnc_setCamo`/`fnc_unsetCamo` before the mod had finished building its internal scheme list (e.g. another addon's own `preInit`, or a very early unit init). Scheme construction now happens in `preInit` instead of `postInit` so it's ready before any mission entity can run, with a one-frame self-defer left in both functions as a safety net for callers that still manage to run earlier than that

## [0.9.3] - 2026-09-13

### Changed

- Enhanced camo functions documentation
- Clarified camouflage itemClasses and enhanced options display
- General code refactoring for readability and maintainability

## [0.9.2] - 2026-09-11

### Added

- Multi-layer camo application with a progress bar
- Public API events for camouflage application and removal
- Zeus Enhanced (ZEN) compatibility

### Fixed

- Texture paths

## [0.9.1] - 2026-09-11

### Added

- Vanilla face support in the camouflage UI

## [0.9.0] - 2026-09-11

### Added

- Initial release (RC1)

[Unreleased]: https://github.com/Andx667/Camo_Faces_Redux/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/Andx667/Camo_Faces_Redux/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.4...v1.0.0
[0.9.4]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.3...v0.9.4
[0.9.3]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/Andx667/Camo_Faces_Redux/releases/tag/v0.9.0
