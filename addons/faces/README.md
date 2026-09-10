# Faces (`cfr_faces`)

Adds the actual camouflaged face variants: a `CfgFaces` entry, texture, and material set for every combination of base head × camo scheme.

## Dependencies

- `cfr_main`

## Structure

- `CfgFaces.hpp` includes one `Faces_<Group>.hpp` file per head group: `Faces_African.hpp`, `Faces_Asian.hpp`, `Faces_Greek.hpp`, `Faces_Persian.hpp`, `Faces_White.hpp`.
- Each of those files defines, per base head (e.g. `WhiteHead_01`), one `CfgFaces` class per camo scheme, inheriting from that head's own `BWTarn` variant:

  ```cpp
  class GVAR(WhiteHead_01_BWTarn): WhiteHead_01 { texture = ...; ... };
  class GVAR(WhiteHead_01_BWStripes): GVAR(WhiteHead_01_BWTarn) { texture = ...; };
  class GVAR(WhiteHead_01_Black): GVAR(WhiteHead_01_BWTarn) { texture = ...; };
  ...
  ```

  Because of the `GVAR()` macro, the actual registered classname is `cfr_faces_<BaseFace>_<Scheme>` — e.g. `cfr_faces_WhiteHead_01_BWTarn`.
- `data/<scheme>/<HeadCode>/` holds the texture (and, for Persian/African/Asian/Greek heads, the `.rvmat`/injury materials) for each base head under that scheme.

## Camo schemes

| Data folder | Scheme | Heads covered |
| --- | --- | --- |
| `bwtarn` | BW Camouflage | All |
| `bwstripes` | BW Stripes | All |
| `black` | Night | All except African heads |
| `serbian` | Serbian | All |
| `usstripes` | US Stripes | All |
| `usstains` | US Stains | All |
| `usflash` | US Flash | All |

[`cfr_common`](../common/README.md) is the sole consumer of these classnames — its `fnc_init` derives its per-scheme lookup lists directly from this addon's `cfr_faces_<BaseFace>_<Scheme>` naming convention (via `FACES_CLASS_PREFIX`), so the two stay in sync.

## Credits

All textures and RVMATs were made by Sk3y and Feldhobel.
