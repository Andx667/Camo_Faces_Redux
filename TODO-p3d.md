# P3D / Model Asset TODO

Consolidated list of everything found that touches `.p3d`, `.rvmat`, or texture files under `addons/items` and `addons/faces`. Pulled together from the open GitHub issues plus two sessions of audit work.

**2026-09-10 update:** Read issues #4 and #5 directly and byte-scanned all three `.p3d` files (they're MLOD/source format, not binarized ODOL, so the string tables are inspectable). This **corrected several assumptions** below — see the `CONFIRMED`/`REVISED` tags. Full execution plan is at the bottom of this file.

**2026-09-10 update 2:** Cross-checked `GVAR(all_faces)` against the Arma 3 config dump in the parent folder (`../Arma3 Config Dump/AiA222.hpp`) and executed stages 1, 2, and 5 of the plan below.

## `addons/items` — facepaint items

- [x] ~~**US_Facepaint.p3d** — internal material reference is lowercase~~ **REVISED — not a bug.** Byte-scanned the whole file: every one of the 2,416 material-path occurrences reads `\z\cfr\addons\items\data\rvmat\US_Facepaint.rvmat` and every one of the 2,416 texture-path occurrences reads `US_Facepaint_co.paa` — correct case throughout, zero lowercase copies exist in this file. The lowercase `us_facepaint.rvmat` / `us_facepaint_co.paa` errors in Issue #5's log actually come from **SERBIAN_Facepaint.p3d** (see below) — it still references US's material internally. Issue #5 misattributed these two lines to the US item. *(Issue #5 — re-scope/close)*
- [x] ~~**US_Facepaint.p3d** — internal diffuse texture reference is lowercase~~ Same correction as above — no fix needed on this file.
- [x] **BW_Facepaint.p3d** — **FIXED.** Byte-scan found 224 occurrences each of `bw_facepaint.rvmat` and `bw_facepaint_co.paa`, all lowercase, all in LOD 0. Patched in place (same-length case-only swap, verified file size unchanged at 83,642 bytes and LOD offsets/sizes identical before/after) to `BW_Facepaint.rvmat` / `BW_Facepaint_co.paa`. Re-scan confirms zero lowercase occurrences remain. *(Issue #5)*
- [ ] **BW_Facepaint.p3d** — texture missing in LOD 1. **CONFIRMED + explained**: the file has exactly 2 LODs. LOD 0 (offset `0xc`, 48200 bytes) contains all the material/texture strings; LOD 1 (offset `0xbc54`, 35430 bytes) contains **zero** texture/material/rvmat strings anywhere — not a mis-cased reference, there's no reference at all. Issue #5's log line `Warnings in bw_facepaint.p3d:shadow(1000)` strongly suggests LOD 1 *is* the shadow-volume LOD, which normally carries no texture by design — so this may not be a bug at all, just Issue #4's reporter comparing LOD 0 to a shadow LOD. **Needs Object Builder** to confirm LOD 1's resolution/name tag; if it's the shadow LOD, close #4 as not-a-bug and fold it into the line below. *(Issue #4)*
- [ ] **BW_Facepaint.p3d** — shadow LOD (`shadow(1000)`) warnings from Issue #5's log. This is the one real open question on BW and needs eyes-on in Object Builder (open LOD 1, run Structure > Find Components / convexity check) — likely a component-naming or non-convex-geometry issue, not texture-related. *(Issue #5 log)*
- [ ] **SERBIAN_Facepaint.p3d** — **REVISED, bigger than described.** Byte-scan found *three* distinct path strings baked into this file, not one:
  - `serbian_facepaint_co.paa` (lowercase, 1208 occurrences) — should be `SERBIAN_Facepaint_co.paa`.
  - `us_facepaint_co.paa` (lowercase, 1208 occurrences) — this is **not a case issue**, a large portion of this model's faces still point at the *wrong texture entirely* (US's, not Serbian's).
  - `us_facepaint.rvmat` (lowercase, 2416 occurrences — i.e. *every* material assignment in the file) — the Serbian item currently has **no self-referencing material at all**; 100% of its faces point at US's rvmat.
  This reads like the model was cloned from `US_Facepaint.p3d` and only the texture was partially repointed to Serbian's, never the material, and never finished for all faces. Case-only patching won't fix this — it needs an actual material reassignment in Object Builder once a real `SERBIAN_Facepaint.rvmat` exists (see next item). *(Issue #5)*
- [ ] **SERBIAN_Facepaint.p3d** material set is incomplete — there's no `SERBIAN_Facepaint.rvmat` at all, and `addons/items/data/tex/` only has `SERBIAN_Facepaint_co.paa` — no `_nohq` (normal map) or `_smdi` (specular map) textures exist for it, unlike BW and US. **This blocks the item above** — the rvmat (and ideally matching normal/spec textures) needs to be authored before Object Builder can reassign Serbian's faces to their own material. Decide: author to match BW/US, or confirm Serbian is intentionally simpler (in which case Stage1/Stage5 in the new rvmat can just omit/stub those maps). *(found previous session — see notes in `US_Facepaint.rvmat`)*
- [ ] Once the above are fixed, do a full LOD/texture check (Buldozer/Object Builder preview) on **all three** facepaint items, not just BW — the log in issue #5 may not be exhaustive.

## `addons/faces` — camo face variants

- [x] **`Faces_Persian.hpp`** — **FIXED.** Every Persian camo variant inherited from the generic `Default` CfgFaces class, while White/Asian/African/Greek all inherit from their real vanilla head class. Confirmed against the Arma 3 config dump that `PersianHead_A3_01` is a real `CfgFaces` class (and `_02`/`_03` inherit from `_01` in vanilla too). Checked the established pattern in `Faces_White.hpp`/`Faces_Greek.hpp`: only the root `_01_BWTarn` class needs to inherit from the real vanilla class — every other numbered variant (`_02`, `_03`, ...) inherits from that same mod-defined root, not from the vanilla class directly. So the fix was minimal: forward-declared `class PersianHead_A3_01;` and re-parented `GVAR(PersianHead_A3_01_BWTarn)` from `Default` to `PersianHead_A3_01`; `_02`/`_03` root classes were already correctly chained through it. *(already flagged inline at the top of the file; found previous session, not from an issue)*
- [x] Verify every base head classname hardcoded in `GVAR(all_faces)` (`addons/common/functions/fnc_init.sqf`) actually exists as a real Arma 3 `CfgFaces` class. **Verified against `../Arma3 Config Dump/AiA222.hpp`** — all 40 classnames (`PersianHead_A3_01-03`, `AsianHead_A3_01-03`, `AfricanHead_01-03`, `GreekHead_A3_01-09`, `WhiteHead_01-21`) exist as real BI-authored `CfgFaces` classes. No renamed/missing classes.
- [x] **`addons/faces/stringtable.xml`** — **FIXED.** `GreekHead_A3_06` through `_09` used placeholder display names (`Name`, `Name7`, `Name8`, `Name9`). The vanilla `GreekHead_A3_06-09` classes' own `displayname` fields are stringtable-key references (`$STR_A3_GreekMen_LastNames15` etc.) with no literal text in the config dump, so there was nothing to copy from BI directly — continued the mod's own existing alphabetical Greek-surname sequence instead (Athanasiadis, Baros, Constantinou, Costas, Doukas → **Efthimiou, Fotiou, Georgiou, Chatzis**), English + German, matching the pattern where only the camo-scheme suffix translates.

## Not included here — separate, non-asset work

Issue #2 (dialog UI → ACE self-action redesign), #3 (ACE self-action vs CBA context menu toggle), and #7 (support for vanilla camo faces) are all code/design work with no `.p3d`/texture changes needed — tracked in their GitHub issues, not here.

## Execution plan

Ordered by dependency and by how much can be done without opening Object Builder.

**1. Text-only fixes — no game tools, low risk, can be scripted directly:** ✅ done 2026-09-10

- `Faces_Persian.hpp`: forward-declared and re-parented the root `_01_BWTarn` class to `PersianHead_A3_01`.
- `stringtable.xml`: replaced the `Name`/`Name7`/`Name8`/`Name9` placeholders for `GreekHead_A3_06`–`_09` with real names (English + German).

**2. Safe scripted binary patch — same-length case-only string swap, no structural change to the MLOD file:** ✅ done 2026-09-10

- `BW_Facepaint.p3d`: swapped all 224 occurrences of `bw_facepaint.rvmat` → `BW_Facepaint.rvmat` and all 224 occurrences of `bw_facepaint_co.paa` → `BW_Facepaint_co.paa`. Verified: file size unchanged (83,642 bytes), LOD 0/LOD 1 offsets and sizes byte-identical, zero lowercase occurrences remain. Still needs a real hemtt/Buldozer load check to visually confirm (not done — no Arma 3 Tools available in this session).

**3. Requires authoring new assets first:** — not started

- Create `SERBIAN_Facepaint.rvmat` (based on `US_Facepaint.rvmat`/`BW_Facepaint.rvmat`'s structure) pointing at `SERBIAN_Facepaint_co.paa`, plus decide whether to author matching `_nohq`/`_smdi` textures or ship without them.

**4. Requires Object Builder (structural edits, can't be done by safe string-patch):** — not started, needs Object Builder open

- `SERBIAN_Facepaint.p3d`: once step 3's rvmat exists, reassign every face currently pointing at `us_facepaint.rvmat`/`us_facepaint_co.paa` to the real Serbian material/texture, and fix the remaining `serbian_facepaint_co.paa` case mismatch. Path-length differences rule out a byte-patch here.
- `BW_Facepaint.p3d`: open LOD 1 to confirm its resolution/name tag (shadow LOD or not) and diagnose the `shadow(1000)` warnings from Issue #5's log.
- All three items: full LOD/texture preview pass in Buldozer/Object Builder after the above land.

**5. Needs the game/Arma 3 Tools open:** ✅ done 2026-09-10

- Cross-checked every classname in `GVAR(all_faces)` against the Arma 3 config dump (`../Arma3 Config Dump/AiA222.hpp`) — all 40 confirmed real.

**Remaining work all requires Object Builder** (stages 3 and 4) — nothing further can be safely automated from text/binary tools alone.
