# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Camouflage for 46 faces added by later DLCs, bringing the total from 39 to 85: Apex (the nine Tanoan heads and Asian 04-07), Contact (the Livonian and Russian heads, plus White 24-32), Laws of War (Greek 11-14 and White 23), Tac-Ops Mission Pack (Barklem, Mavros and Sturrock) and Tanks (Ioannou). Most only appear for players who actually own the relevant DLC, the same way the Vanilla scheme already does for Marksmen owners - Barklem, Mavros, Sturrock and Ioannou are the exception: they're named campaign personas, but their faces are ordinary, non-disabled heads that any mission can put a unit in regardless of who owns the DLC, so camo for them isn't optional to skip. Night isn't offered on the African, Tanoan or Barklem heads, whose skin is dark enough that black paint reads as almost nothing. This roughly triples the mod's install size (textures alone grow from ~115 MB to ~310 MB)
- Marksmen's three environment-specific camo faces — arid, lush and semi-arid — are now selectable alongside the renamed "Vanilla Camouflage (Standard)" scheme. Bohemia authored these for only three faces, so they are offered to `PersianHead_A3_01`, `GreekHead_A3_02` and `WhiteHead_11` and hidden for everyone else

### Fixed

- Snow Stripes listed in the camo scheme table in the faces component documentation, which had been missing it

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

[Unreleased]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.3...HEAD
[0.9.3]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/Andx667/Camo_Faces_Redux/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/Andx667/Camo_Faces_Redux/releases/tag/v0.9.0
