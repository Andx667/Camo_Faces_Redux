# P3D / Model Asset TODO

Consolidated list of everything found that touches `.p3d`, `.rvmat`, or texture files under `addons/items` and `addons/faces`. Pulled together from the open GitHub issues plus two sessions of audit work.

**2026-09-10 update:** Read issues #4 and #5 directly and byte-scanned all three `.p3d` files (they're MLOD/source format, not binarized ODOL, so the string tables are inspectable). This **corrected several assumptions** below — see the `CONFIRMED`/`REVISED` tags. Full execution plan is at the bottom of this file.

**2026-09-10 update 2:** Cross-checked `GVAR(all_faces)` against the Arma 3 config dump in the parent folder (`../Arma3 Config Dump/AiA222.hpp`) and executed stages 1, 2, and 5 of the plan below.

**2026-09-10 update 3:** User opened all three items in Object Builder/VS Code preview — all three show a 2nd LOD named "Unknown 100001", but it only renders broken on BW. Re-scanned LOD boundaries on all three files to confirm why: US and SERBIAN's LOD 1 both carry real (if occasionally wrong) material/texture strings, so the "Unknown 100001" tag is just this mod's own convention for LOD 1 and is **not** the bug. BW's LOD 1 is the only one with zero texture/material strings at all. This **reverses last update's "maybe it's a shadow LOD, not a bug" theory** — Issue #4 is confirmed a real, simple bug: BW's LOD 1 is just missing the assignment that US/Serbian's LOD 1 already has correctly.

## `addons/items` — facepaint items

- [x] ~~**US_Facepaint.p3d** — internal material reference is lowercase~~ **REVISED — not a bug.** Byte-scanned the whole file: every one of the 2,416 material-path occurrences reads `\z\cfr\addons\items\data\rvmat\US_Facepaint.rvmat` and every one of the 2,416 texture-path occurrences reads `US_Facepaint_co.paa` — correct case throughout, zero lowercase copies exist in this file. The lowercase `us_facepaint.rvmat` / `us_facepaint_co.paa` errors in Issue #5's log actually come from **SERBIAN_Facepaint.p3d** (see below) — it still references US's material internally. Issue #5 misattributed these two lines to the US item. *(Issue #5 — re-scope/close)*
- [x] ~~**US_Facepaint.p3d** — internal diffuse texture reference is lowercase~~ Same correction as above — no fix needed on this file.
- [x] **BW_Facepaint.p3d** — **FIXED.** Byte-scan found 224 occurrences each of `bw_facepaint.rvmat` and `bw_facepaint_co.paa`, all lowercase, all in LOD 0. Patched in place (same-length case-only swap, verified file size unchanged at 83,642 bytes and LOD offsets/sizes identical before/after) to `BW_Facepaint.rvmat` / `BW_Facepaint_co.paa`. Re-scan confirms zero lowercase occurrences remain. *(Issue #5)*
- [ ] **BW_Facepaint.p3d** — texture missing in LOD 1. **CONFIRMED real bug, simpler fix than thought.** All three items have a 2nd LOD tagged "Unknown 100001" by Object Builder/hemtt's viewer — that's just this mod's own LOD-1 convention across the board, not the bug (US and Serbian's LOD 1 both carry real material/texture strings and render fine despite the "Unknown" label). BW's LOD 1 (offset `0xbc54`, 35430 bytes) is the only one with **zero** texture/material/rvmat strings — the assignment is simply missing. **Fix in Object Builder**: select all faces in LOD 1 and assign the `BW_Facepaint` material/texture, mirroring LOD 0 (and what US/Serbian's LOD 1 already correctly do). No resolution-value changes needed — leave "Unknown 100001" as-is, it's evidently intentional. *(Issue #4)*
- [ ] **BW_Facepaint.p3d** — shadow LOD warnings from Issue #5's log (`Warnings in bw_facepaint.p3d:shadow(1000)`). Now that LOD 1 is confirmed as an ordinary (if mislabeled) resolution LOD rather than a shadow volume, this log line likely refers to a genuinely separate/missing shadow LOD, or a warning about the *lack* of one. Needs eyes-on in Object Builder: check whether a Shadow Volume LOD (resolution `1.0e4`/10000) exists at all in this file; if not, that's likely the real source of this warning and may need a shadow LOD added. *(Issue #5 log)*
- [ ] **SERBIAN_Facepaint.p3d** — **REVISED, bigger than described, and inconsistent between its own LODs.** Byte-scan (both LODs individually) found:
  - LOD 0: material `us_facepaint.rvmat` (wrong — should be Serbian's own), texture `serbian_facepaint_co.paa` (own file, but lowercase — 24-char case-only fix, same length as `SERBIAN_Facepaint_co.paa`).
  - LOD 1: material `us_facepaint.rvmat` (wrong, same as LOD 0), texture **`us_facepaint_co.paa`** (wrong — LOD 1 doesn't even match LOD 0's texture choice, it points at US's texture entirely).
  100% of faces in both LODs point at US's rvmat; texture assignment is inconsistent between the two LODs. Reads like the model was cloned from `US_Facepaint.p3d` and only LOD 0's texture was partially repointed to Serbian's, material never fixed anywhere, LOD 1 never touched at all. Case-only patching can fix the LOD 0 texture string once decided (see below); the material (both LODs) and LOD 1's texture need an actual reassignment in Object Builder once a real `SERBIAN_Facepaint.rvmat` exists (see next item). *(Issue #5)*
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

**2b. Same-length case fix, blocked by permission denial:** — not done

- `SERBIAN_Facepaint.p3d`: LOD 0's `serbian_facepaint_co.paa` → `SERBIAN_Facepaint_co.paa` is a same-length (24 chars) case-only swap, identical in nature to the BW fix — confirmed safe but the auto-mode classifier blocked running the patch script. Needs explicit user approval to retry, or can just be done by hand in Object Builder alongside the material reassignment below.

**4. Requires Object Builder (structural edits, can't be done by safe string-patch):** — not started, needs Object Builder open

- `BW_Facepaint.p3d`: select all faces in LOD 1 and assign the `BW_Facepaint` material/texture (mirrors LOD 0 exactly; confirmed this is the actual bug, not a by-design shadow LOD — see 2026-09-10 update 3 above). Separately, check whether a real Shadow Volume LOD (resolution `1.0e4`) exists at all — its absence may be the source of Issue #5's `shadow(1000)` warning.
- `SERBIAN_Facepaint.p3d`: once step 3's rvmat exists, reassign every face in **both LODs** currently pointing at `us_facepaint.rvmat` to the real Serbian material, and every face pointing at `us_facepaint_co.paa` (LOD 1) or the not-yet-patched `serbian_facepaint_co.paa` (LOD 0) to `SERBIAN_Facepaint_co.paa`.
- All three items: full LOD/texture preview pass in Buldozer/Object Builder after the above land.

**5. Needs the game/Arma 3 Tools open:** ✅ done 2026-09-10

- Cross-checked every classname in `GVAR(all_faces)` against the Arma 3 config dump (`../Arma3 Config Dump/AiA222.hpp`) — all 40 confirmed real.

**Remaining work all requires Object Builder** (stages 3 and 4) — nothing further can be safely automated from text/binary tools alone.
