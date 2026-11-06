# Camo Faces Redux (Camo_Faces_Redux)

Arma 3 mod built on CBA and ACE, packaged with HEMTT. It runs inside large modsets next to other mods and must load cleanly beside them; other mods and missions should be able to build on it.

- **Prefix**: `cfr` (globals `cfr_<component>_*`, classnames `cfr_*`)
- **Docs**: `docs/` (MkDocs, published to <https://andx667.github.io/Camo_Faces_Redux/>)
- **Hard dependencies**: CBA_A3, ACE3 (optional: ZEN via `compat_zen`)

## Guiding principles

When a rule below conflicts with these, these win.

1. **Smallest change that solves the problem.** Targeted fixes over rewrites. Don't refactor, rename or reformat code outside the task; propose it separately.
2. **Simple over clever.** No new abstraction layers, generic managers or configurability nobody asked for. A helper earns its place when it is used in several places today.
3. **Reuse before you write.** If CBA, ACE or vanilla already provides it, use that. The repo should only contain what is specific to this mod.
4. **Be a good neighbour.** Expose behaviour through documented functions and events, never break other mods' configs or globals, keep public contracts stable.
5. **Match the surroundings.** Follow the patterns of the file and component you are editing.
6. **Done means verified and documented.** `hemtt check` passes, docs and changelog are updated, and the PR says what was and wasn't tested in-game.

If a task is ambiguous or seems to need a large change, propose the approach and a smaller alternative before writing code.

## CBA and ACE as the baseline

| Need | Use |
|---|---|
| Init and class event handlers | CBA XEH (`XEH_preInit`, `XEH_postInit`, `CfgEventHandlers.hpp`) |
| Function compilation | `PREP(...)` in `XEH_PREP.hpp` |
| Settings | `CBA_fnc_addSetting` — no custom params dialogs or hard-coded toggles |
| Keybinds | `CBA_fnc_addKeybind` |
| Networking, reacting to change | CBA events (`localEvent`, `serverEvent`, `targetEvent`, `globalEvent`, `globalEventJIP`) — not `remoteExec` or `publicVariable` polling |
| Delays and waiting | `CBA_fnc_waitAndExecute`, `CBA_fnc_waitUntilAndExecute`, `CBA_fnc_execNextFrame` |
| Repeated checks | `CBA_fnc_addPerFrameHandler` with an interval, removed when done |
| Interactions, progress bars | ACE interaction menu, `ace_common_fnc_progressBar` |
| Cargo, dragging, medical, arsenal | The ACE component's public functions and config entries |

Search CBA, ACE and this repo's common addon before writing a helper. Don't depend on third-party functions that aren't marked public.

## Public API and events

Other mods, missions and Zeus users depend on these. Treat them as a contract.

- A function is public only if its header says `Public: Yes`. Everything else is internal.
- Public functions and events are documented for users with arguments, return value, example and locality.
- API events are named `QGVAR(API_<somethingHappened>)` (past tense) and fire when a state change completes, from the machine where it happened.
- Event arguments are plain, stable values (objects, strings, numbers, arrays), not internal structures.
- **Append-only**: new arguments go at the end with a default in `params`; never reorder or change meaning.
- **Deprecate, don't break**: keep the old name working, log `WARNING_1`, mark it in header and docs, add a `deprecated` changelog entry, remove it no earlier than the next major version.
- Never write to another mod's variables or functions except through their documented API.
- Compat addons live in `addons/compat_<mod>/`, list the other mod in `requiredAddons[]` and set `skipWhenMissingDependencies = 1`. Non-compat addons don't depend on optional mods.
- Patch other configs by inheritance with the smallest override; don't `delete` classes you don't own.
- Detect optional mods once at init with `isClass (configFile >> "CfgPatches" >> "<addon>")` and cache the result.

## Coding guidelines

Follow the ACE3 coding guidelines: <https://ace3.acemod.org/wiki/development/coding-guidelines>

- Component layout: `addons/<component>/` with `$PBOPREFIX$`, `config.cpp`, `script_component.hpp`, XEH files, `functions/fnc_*.sqf`, `README.md`.
- Macros (`GVAR`, `QGVAR`, `EGVAR`, `FUNC`, `EFUNC`, `QPATHTOF`) instead of hardcoded prefixed strings.
- Every function has the ACE header (`Author`, description, `Arguments`, `Return Value`, `Example`, `Public`).
- Typed `params` with defaults; `private` for every local; 4 spaces, no tabs.
- User-facing text only via `stringtable.xml`.
- Guard clauses with `exitWith` — inside `if/then` it only exits that block.
- CBA log macros instead of `diag_log`; no RPT spam in normal operation.

## Locality, networking and performance

- Costs multiply by every client and every frame: no scheduled polling loops, no `onEachFrame`, no unnecessary `spawn`.
- Prefer events over polling. If a per-frame check is needed, use a PFH with an interval and remove it afterwards. Remove JIP events that are no longer needed.
- Server logic behind `isServer`, UI and player logic behind `hasInterface`. Send work to the owner with `CBA_fnc_targetEvent`.
- Keep network traffic small: one event with the needed data, not one per unit per tick.

## Documentation

- **`addons/<component>/README.md`** — for developers: how it works and why.
- **Function headers and comments** — comments explain constraints and workarounds, not what the code does.
- **User docs** — for mission makers: what it does, settings, public functions and events, in plain language.

A behaviour change without matching docs updates is incomplete.

## Git workflow

- Never commit directly to the default branch; work on a feature branch and merge via PR.
- Branch names: `<type>/<component>-<short-description>`, type is `feature`, `fix`, `docs`, `refactor`, `compat` or `ci`.
- One topic per branch and PR; formatting and unrelated fixes get their own PR.
- Commit messages and PR titles: `Component - Add|Fix|Change|Remove {changes}`.
- Keep the branch current with the default branch before review.

## Pull requests

- Follow `.github/PULL_REQUEST_TEMPLATE.md` if present. Title format as above; it becomes the release note, so write it for players.
- Description: one bullet per change, plus a list of what is untested or open (e.g. "not tested on a dedicated server").
- One changelog label: `changelog/added|changed|deprecated|removed|fixed|security`, or `ignore-changelog` for changes without user impact.
- Open larger work early as a draft. Merge only with passing CI and a review.

## Changelog and versioning

- `CHANGELOG.md` follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [SemVer](https://semver.org/).
- Every user-visible PR adds a line under `## [Unreleased]`: `* Component - Fix … (#<PR>) by <author>`. The section matches the label.
- **Major**: removing or renaming public functions, events, settings, mission-used classnames. **Minor**: new features, public API, settings, deprecations. **Patch**: fixes without contract changes.
- Don't bump the version in feature PRs unless asked.

## Verification

1. `hemtt check` passes with no new errors or warnings; fix lints instead of suppressing them.
2. Run the repo's CI checks locally where possible.
3. Re-read the diff: minimal, only intended files, docs and changelog updated.
4. State in the PR what needs in-game testing (local host vs. dedicated server, JIP) instead of claiming it works.

## Don'ts

- No rewrites of working components without an agreed issue.
- No new dependencies beyond CBA/ACE outside compat addons.
- No `remoteExec`/`publicVariable` where a CBA event fits; no scheduled polling.
- No public functions or events "just in case".
- No unrelated formatting changes in functional PRs.
