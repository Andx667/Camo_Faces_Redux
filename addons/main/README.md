# Main (`cfr_main`)

The main addon for Camo Faces Redux. It carries no gameplay logic of its own — every other `cfr_*` component includes its headers and depends on it being loaded first.

## Dependencies

- `cba_main`

## Responsibilities

- Defines the mod-wide preprocessor macros used by every other component (`script_mod.hpp`, `script_macros.hpp`), including the `PREFIX`/`COMPONENT` definitions that back the `GVAR`/`FUNC`/`EGVAR`/`QGVAR`/... macro family every addon uses.
- Declares the mod's version (`script_version.hpp`) and its CBA Versioning dependency on `cba_main` (`CfgSettings.hpp`).
- Registers the mod's Zeus/Eden editor sub-category, **CFR** (`CfgEditorSubCategories.hpp`).
- Registers the mod's faction, **CFR** (`CfgFactionClasses.hpp`), used by `cfr_items`' supply box.

## Files

| File | Purpose |
| --- | --- |
| `script_mod.hpp` | `MAINPREFIX`/`PREFIX`/`AUTHOR`/mod name/version macros; included by every component before `script_macros.hpp` |
| `script_macros.hpp` | Pulls in CBA's and ACE's macro sets, then adds this mod's own (`PATHTOF2`/`QPATHTOF2`, the `PREP`/`PREP_RECOMPILE_*` compile-cache switch, cargo/weapon/magazine helper macros) |
| `script_version.hpp` | `MAJOR`/`MINOR`/`PATCH` version numbers |
| `CfgSettings.hpp` | CBA Versioning integration and the `cba_main` version dependency |
| `CfgEditorSubCategories.hpp` | The **CFR** Zeus/Eden editor sub-category, referenced by `cfr_items`' box |
| `CfgFactionClasses.hpp` | The **CFR** faction, referenced by `cfr_items`' box |

There is no `functions/` folder — this addon is configuration-only.
