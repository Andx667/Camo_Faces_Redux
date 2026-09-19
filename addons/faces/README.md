# Faces (`cfr_faces`)

Adds the actual camouflaged face variants: a `CfgFaces` entry, texture, and material set for every combination of base head × camo scheme.

## Dependencies

- `cfr_main`

## Structure

- `CfgFaces.hpp` includes one `Faces_<Group>.hpp` file per head group: `Faces_African.hpp`, `Faces_Asian.hpp`, `Faces_Greek.hpp`, `Faces_Persian.hpp`, `Faces_White.hpp`, plus `Faces_Tanoan.hpp`, `Faces_Livonian.hpp` and `Faces_Russian.hpp` for the DLC head groups.
- Each of those files defines, per base head (e.g. `WhiteHead_01`), one `CfgFaces` class per camo scheme, inheriting from that head's own `BWTarn` variant:

  ```cpp
  class GVAR(WhiteHead_01_BWTarn): WhiteHead_01 { texture = ...; ... };
  class GVAR(WhiteHead_01_BWStripes): GVAR(WhiteHead_01_BWTarn) { texture = ...; };
  class GVAR(WhiteHead_01_Black): GVAR(WhiteHead_01_BWTarn) { texture = ...; };
  ...
  ```

  Because of the `GVAR()` macro, the actual registered classname is `cfr_faces_<BaseFace>_<Scheme>` — e.g. `cfr_faces_WhiteHead_01_BWTarn`.
- `data/<scheme>/<HeadCode>/` holds the texture for each base head under that scheme, plus its `.rvmat`/injury materials where they are needed. A head only needs them when its *vanilla* rvmat hardcodes a `_co` texture path, which then has to be redirected at CFR's texture; the African heads and `TanoanHead_A3_01` use a different material setup that takes the diffuse from the `CfgFaces` `texture` property alone, so they ship no rvmats and simply inherit the vanilla material.

## Camo schemes

| Data folder | Scheme | Heads covered |
| --- | --- | --- |
| `bwtarn` | BW Camouflage | All |
| `bwstripes` | BW Stripes | All |
| `black` | Night | All except heads with African skin tones (African, Tanoan, Barklem) |
| `serbian` | Serbian | All |
| `usstripes` | US Stripes | All |
| `usstains` | US Stains | All |
| `usflash` | US Flash | All |
| `snowstripes` | Snow Stripes | All |

## DLC heads

Alongside the base game's 39 heads, the mod covers 46 heads added by later DLCs — Apex (Tanoan, plus Asian 04-07), Contact (Livonian, Russian, White 24-32), Laws of War (Greek 11-14, White 23), Tac-Ops Mission Pack (Barklem, Mavros, Sturrock) and Tanks (Ioannou). Their `CfgFaces` classes are defined unconditionally, exactly as the Vanilla scheme already references BI's Marksmen `CamoHead_*` faces; ownership is enforced at runtime instead, by the `isDLCAvailable` gate in [`cfr_common`](../common/README.md)'s `fnc_init`, so a player without a given DLC never sees those faces offered anywhere.

Barklem, Mavros, Sturrock and Ioannou are named campaign personas rather than generic soldiers, but their `CfgFaces` classes are ordinary, non-disabled heads underneath — a mission can put any unit in one of these faces regardless of who owns the DLC, so they get camo like every other head.

Note that the `Vanilla` scheme cannot cover them: its pairs are BI's own `CamoHead_*` faces, which exist only for the base game's original 39 heads.

[`cfr_common`](../common/README.md) is the sole consumer of these classnames, and learns about them through a config registry rather than any list of its own: `CfgCamoRegistry.hpp` here declares every base face (with its `requiredDLC` gate, if any) and, per scheme, which of this addon's `cfr_faces_<BaseFace>_<Scheme>` classes each face maps to. It is generated from the classes in `Faces_*.hpp` by `tools/camo_generator/generate_registry.py` (`validate.py wiring` fails if the two drift apart), so adding a head means generating its classes and re-running that script. A scheme's absence for a face - Black on the African and Tanoan heads and Barklem - is simply a missing entry. `CfgCamoVanilla.hpp` is the hand-written counterpart for Bohemia's own Marksmen camo faces. This is the same extension mechanism other addons use to register their own faces - see "Extending the mod" in `cfr_common`'s README.

## Credits

The camo schemes themselves — every pattern, its colours and its placement — were designed and painted by Sk3y and Feldhobel, who authored the textures and RVMATs for the base game's 39 heads.

The textures for the 46 DLC heads were not painted by hand. Each scheme's paint layer was recovered from the shipped textures (modelling every pixel as `camo = base * (1 - alpha) + alpha * paint_colour`, then solving for `alpha` and the paint colour across all 34 authored reference faces) and composited onto the DLC heads' vanilla textures. This works because every `Man_A3` head shares one UV layout, so a scheme's artwork lands in exactly the same place on any face. Validated by reconstructing each authored face from the others: SnowStripes, the one scheme with a clean uncompressed source, comes back to within 0.17/255 of the original.
