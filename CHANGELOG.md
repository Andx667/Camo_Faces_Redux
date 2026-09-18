# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-09-18

### Added

- Camouflage for 46 faces added by later DLCs, bringing the total from 39 to 85: Apex (the nine Tanoan heads and Asian 04-07), Contact (the Livonian and Russian heads, plus White 24-32), Laws of War (Greek 11-14 and White 23), Tac-Ops Mission Pack (Barklem, Mavros and Sturrock) and Tanks (Ioannou). Most only appear for players who actually own the relevant DLC, the same way the Vanilla scheme already does for Marksmen owners - Barklem, Mavros, Sturrock and Ioannou are the exception: they're named campaign personas, but their faces are ordinary, non-disabled heads that any mission can put a unit in regardless of who owns the DLC, so camo for them isn't optional to skip. Night isn't offered on the African, Tanoan or Barklem heads, whose skin is dark enough that black paint reads as almost nothing. This roughly triples the mod's install size (textures alone grow from ~115 MB to ~310 MB)
- Marksmen's three environment-specific camo faces — arid, lush and semi-arid — are now selectable alongside the renamed "Vanilla Camouflage (Standard)" scheme. Bohemia authored these for only three faces, so they are offered to `PersianHead_A3_01`, `GreekHead_A3_02` and `WhiteHead_11` and hidden for everyone else
- Configurable camo wear-off timer: a CBA setting (slider, 0 to 240 minutes, default 0/disabled) that automatically restores a unit's original face a set number of minutes after camo is applied, simulating it fading from rain, sweat, or time
- Camo face now travels with a unit's loadout through CBA's Extended Loadout framework (`CBA_fnc_getLoadout`/`CBA_fnc_setLoadout`), so it survives round trips like ACE Arsenal's loadout export/import or a mission's own loadout persistence — previously only respawn/JIP reapplication on the same unit was covered

### Changed

- First stable release: dropped the "[Beta]" tag from the mod's display name and the beta disclaimer from the Steam Workshop description

### Fixed

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

[Unreleased]: https://github.com/Andx667/Camo_Faces_Redux/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.4...v1.0.0
[0.9.4]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.3...v0.9.4
[0.9.3]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/Andx667/Camo_Faces_Redux/releases/tag/v0.9.0
