# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Camouflage for 42 faces added by later DLCs, bringing the total from 39 to 81: Apex (the nine Tanoan heads and Asian 04-07), Contact (the Livonian and Russian heads, plus White 24-32) and Laws of War (Greek 11-14 and White 23). Each DLC's faces only appear for players who actually own it, using the same availability check the Vanilla scheme already uses for Marksmen
- Marksmen's three environment-specific camo faces — arid, lush and semi-arid — are now selectable alongside the Vanilla scheme. Bohemia authored these for only three faces, so they are offered to `PersianHead_A3_01`, `GreekHead_A3_02` and `WhiteHead_11` and hidden for everyone else
- Snow Stripes listed in the camo scheme table in the faces component documentation, which had been missing it

### Fixed

- The dialog no longer offers the Vanilla category to a unit whose face has no vanilla camo variant, where it would previously open an empty pattern list. Vanilla's variants are Bohemia's own and exist only for the base game's original 39 faces

### Changed

- `cfr_common`'s `GVAR(faces_african)` is now `GVAR(faces_noBlack)`, since the Tanoan heads join the African ones in having no Night variant — black paint on skin that dark reads as almost nothing

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
