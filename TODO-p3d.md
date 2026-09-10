# P3D / Model Asset TODO

Consolidated list of everything found that touches `.p3d`, `.rvmat`, or texture files under `addons/items` and `addons/faces`. Nothing here has been changed yet — pulled together from the open GitHub issues plus this session's audit, for when the models are opened.

## `addons/items` — facepaint items

- [ ] **US_Facepaint.p3d** — internal material reference is lowercase (`us_facepaint.rvmat`), doesn't match the real file `US_Facepaint.rvmat`. Confirmed the rvmat files themselves are clean (scanned all 436 rvmats in the repo, zero case mismatches) — this reference is baked into the `.p3d`'s own face material assignment. *(Issue #5)*
- [ ] **US_Facepaint.p3d** — internal diffuse texture reference is lowercase (`us_facepaint_co.paa`) vs the real file `US_Facepaint_co.paa`. *(Issue #5)*
- [ ] **BW_Facepaint.p3d** — same lowercase material reference issue (`bw_facepaint.rvmat` vs real `BW_Facepaint.rvmat`). *(Issue #5)*
- [ ] **BW_Facepaint.p3d** — same lowercase diffuse texture reference issue (`bw_facepaint_co.paa` vs real `BW_Facepaint_co.paa`). *(Issue #5)*
- [ ] **BW_Facepaint.p3d** — texture missing in LOD 1 (shows fine in LOD 0, per hemtt viewer). *(Issue #4)*
- [ ] **BW_Facepaint.p3d** — shadow LOD (`shadow(1000)`) reported warnings in the same load log as the texture errors — check shadow geometry/component naming. *(Issue #5 log)*
- [ ] **SERBIAN_Facepaint.p3d** — internal diffuse texture reference is lowercase (`serbian_facepaint_co.paa`) vs real file `SERBIAN_Facepaint_co.paa`. *(Issue #5)*
- [ ] **SERBIAN_Facepaint.p3d** material set is incomplete — there's no `SERBIAN_Facepaint.rvmat` at all, and `addons/items/data/tex/` only has `SERBIAN_Facepaint_co.paa` — no `_nohq` (normal map) or `_smdi` (specular map) textures exist for it, unlike BW and US. Decide: author the missing rvmat + normal/specular textures to match BW/US, or confirm Serbian is intentionally simpler. *(found this session — see notes in `US_Facepaint.rvmat`)*
- [ ] Once the above are fixed, do a full LOD/texture check (Buldozer/Object Builder preview) on **all three** facepaint items, not just BW — the log in issue #5 may not be exhaustive.

## `addons/faces` — camo face variants

- [ ] **`Faces_Persian.hpp`** — every Persian camo variant inherits from the generic `Default` CfgFaces class, while White/Asian/African/Greek all inherit from their real vanilla head class (`WhiteHead_01`, etc. — forward-declared at the top of each of those files). Decide whether Persian should inherit from `PersianHead_A3_01`/`_02`/`_03` instead. *(already flagged inline at the top of the file; found this session, not from an issue)*
- [ ] Verify every base head classname hardcoded in `GVAR(all_faces)` (`addons/common/functions/fnc_init.sqf`) actually exists as a real Arma 3 `CfgFaces` class — couldn't be checked without the game/tools open. A wrong/renamed name would silently mean that head can never receive camo (no error, it would just never match).
- [ ] **`addons/faces/stringtable.xml`** — `GreekHead_A3_06` through `_09` still use placeholder display names (`Name`, `Name7`, `Name8`, `Name9`) instead of real character names like the rest of the Greek heads have. Not a `.p3d`/`.rvmat` file itself, but part of the same face-asset pass. *(already flagged inline; found this session)*

## Not included here — separate, non-asset work

Issue #2 (dialog UI → ACE self-action redesign), #3 (ACE self-action vs CBA context menu toggle), and #7 (support for vanilla camo faces) are all code/design work with no `.p3d`/texture changes needed — tracked in their GitHub issues, not here.
