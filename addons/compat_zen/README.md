# Compat - Zeus Enhanced (`cfr_compat_zen`)

Optional compatibility addon: lets a Zeus curator apply or remove camouflage on any unit(s) directly from [Zeus Enhanced](https://github.com/zen-mod/ZEN) (ZEN)'s own context menu, bypassing the item/headgear preconditions the dialog and ACE self-action flows enforce (the same way Zeus's built-in Identity attribute can set a face directly).

This PBO only loads if ZEN's `zen_context_menu` component is present — see `requiredAddons`/`skipWhenMissingDependencies` in `config.cpp`. If ZEN isn't loaded, this addon is silently inert and the rest of the mod is unaffected.

Also gated by a CBA setting, `GVAR(enableContextActions)` (**Enable Camouflage Context Actions**, under the mod's **Zeus Enhanced** settings category) — a `CHECKBOX`, default on, registered with `isGlobal = 2` in `XEH_preInit.sqf`. `isGlobal = 2` is the same "not synced" scope `cfr_dialog`'s `useAceActions` setting uses: it's a per-client value with no server override, appropriate here since it's a personal Zeus UI preference, not mission state - so each curator can turn it off individually without affecting anyone else. The top-level `CFR_Camouflage` menu node's `condition` checks it directly.

## Dependencies

- `cfr_common`
- `cfr_items` (for the context menu icon)
- `zen_context_menu` (only present if [ZEN](https://github.com/zen-mod/ZEN) is loaded)

## How it hooks into ZEN

`CfgContext.hpp` extends ZEN's own `zen_context_menu_actions` config class (a foreign mod's class — written with its literal name, not via `EGVAR()`, since that macro only reaches this mod's own components) with a single dynamic node, `CFR_Camouflage`. Its `insertChildren` calls `fnc_getCamoActions` on every menu open, which inspects the current Zeus selection (`_objects`/`_groups`, provided by ZEN) and builds the menu differently depending on what's selected:

- **Exactly one applicable unit selected** (currently on one of this mod's supported base faces) — one action per camo scheme available for that unit's face, each applying that specific scheme (`fnc_setCamo` in `cfr_common`, called directly).
- **More than one applicable unit selected** — a single "Apply Random Camouflage" action (`fnc_applyRandomCamo`) that gives each selected unit its own independent random pick from its available schemes.
- **Any selected unit currently has camo applied** — a "Remove Camouflage" action (`fnc_removeCamo`) is added regardless of the above, restoring each such unit's base face.

See [ZEN's own context menu action config](https://github.com/zen-mod/ZEN/blob/master/addons/context_actions/CfgContext.hpp) for the `condition`/`statement`/`insertChildren`/`args` convention this follows — `_objects`, `_groups`, and a leaf action's own `_args` are available as bare local variables inside any `condition`/`statement`/`insertChildren` code, via ZEN's `SETUP_ACTION_VARS`/`ACTION_PARAMS` scope-chaining, not passed explicitly.

## Functions

| Function | Arguments | Description |
| --- | --- | --- |
| `fnc_getCamoActions` | `[objects, groups]` | Builds the dynamic ZEN menu children described above |
| `fnc_applyRandomCamo` | `[units]` | Applies a random available scheme to each unit independently, skipping units with no supported base face |
| `fnc_removeCamo` | `[units]` | Removes camouflage from each unit |

`cfr_common` also gained one small addition to support this: `fnc_getSchemeDisplayName` (`[schemeId] → localized display name`), used to label each per-scheme action.
