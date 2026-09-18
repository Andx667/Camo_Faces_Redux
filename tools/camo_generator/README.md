# Camo generator

Applies the mod's existing camo schemes to heads nobody painted by hand, and writes the config
that goes with them. This is what produced the 46 DLC heads in `addons/faces`.

## How it works

Every `Man_A3` head shares one UV layout, so a scheme's artwork lands on exactly the same
pixels whichever face it is painted on. That makes a scheme's paint separable from the skin
underneath. Each painted pixel is modelled as

```text
camo = base * (1 - alpha) + alpha * paint_colour
```

where `alpha` and `paint_colour` belong to the scheme rather than to any one face. Fitting
across the hand-painted faces — whose skin tones differ — is what separates the two; from a
single face they are indistinguishable. The fit has a closed form, so a whole 1024x1024 layer
solves at once, and the recovered layer can then be composited onto any other head.

The result is only as good as that claim, so `validate.py fit` tests it directly: it rebuilds
each hand-painted face from the *others* and compares against the texture the mod ships.
SnowStripes is the sharpest test, being the one scheme whose source carries no DXT round-trip
noise — it reconstructs to about 0.17 of a 0-255 level. The rest land at the compression noise
floor, around 2.5, and comfortably beat naive delta-transfer.

## Requirements

- Python 3 with `numpy` and `pillow`
- [HEMTT](https://hemtt.dev) on `PATH` — used for all PBO and PAA work
- Arma 3 installed, including the DLCs whose heads you are generating

Optional environment variables (see `paths.py`): `CFR_ARMA3`, `CFR_WORK`, `CFR_CONFIG_DUMP`.

## Running it

```sh
python extract.py             # vanilla textures + the mod's own camo textures -> PNG
python validate.py fit        # confirm the model still reconstructs the shipped faces
python generate_textures.py   # fit each scheme, composite onto the new heads, write PAAs
python generate_materials.py  # write each head's .rvmat / _injury.rvmat
python generate_config.py     # CfgFaces classes + stringtable entries
hemtt ln sort                 # generate_config.py appends; this re-sorts the stringtable
python validate.py wiring     # face lists <-> config classes <-> textures on disk
python validate.py names      # every camo face is named after its own head
hemtt build
```

`generate_config.py` **appends** to the pre-existing `Faces_White/Asian/Greek/African.hpp` (and
skips any head already present in a group's file or the stringtable), so it is safe to re-run
after adding more heads to `NEW` without reverting `addons/faces` first.

## Adding more heads

1. Add them to `NEW` in `faces.py`.
2. Add them to the DLC face list in `cfr_common`'s `fnc_init.sqf`, under the right App ID, so
   the `isDLCAvailable` gate covers them.
3. Run `resolve_vanilla.py` (needs `CFR_CONFIG_DUMP`) to refresh `data/names.json` and
   `data/vanilla_props.json`, then the pipeline above. `names.json` covers the hand-written heads
   too, which is what lets `validate.py names` run offline. If a head is a named campaign persona
   (e.g. Barklem, Mavros), its display-name string may live in that DLC's `languagemissions_f_*`
   PBO rather than its `language_f_*` one - add both to `LANG_PBOS` if names come back unresolved.

Four things are easy to get wrong, and all four are handled by the scripts rather than by
assumption — worth knowing if you extend them:

- **A head needs its own `.rvmat` only when its vanilla rvmat hardcodes a `_co` path** that has
  to be redirected. The African heads and `TanoanHead_A3_01` use a setup that takes the diffuse
  from the `CfgFaces` `texture` property instead, so they correctly ship none.
- **A head can have its own base rvmat but no vanilla injury rvmat of its own**, inheriting the
  wound material unchanged - true of Barklem, Mavros and Sturrock. `generate_config.py` checks
  for the injury rvmat's own existence rather than assuming one exists whenever the base one does.
- **Map paths must be read from each vanilla rvmat, never derived from the head's name.**
  `m_tanoan_01` reuses `m_african_03`'s normal and specular maps.
- **A CFR camo class inherits its group's *first* head**, so anything the real head overrides
  has to be restated or it is silently lost. 21 of the 42 original DLC heads needed their
  hairline textures carried over; without it Old Man wears a bald Tanoan scalp instead of his
  grey hair.

## Files

| File | Purpose |
| --- | --- |
| `paths.py` | Locating the repo, the game, and the scratch directory |
| `faces.py` | Which heads are covered, their folder codes, DLC and App ID |
| `paintlayer.py` | The paint-layer model: fitting and compositing |
| `extract.py` | Stage 1 — pull vanilla and shipped textures out of the PBOs |
| `generate_textures.py` | Stage 2 — fit each scheme and composite onto the new heads |
| `generate_materials.py` | Stage 3 — write the `.rvmat` files |
| `generate_config.py` | Stage 4 — write the `CfgFaces` classes and stringtable entries |
| `resolve_vanilla.py` | Refresh `data/` from the game (only needed when adding heads) |
| `validate.py` | `fit` — is the model sound; `wiring` — do config and files agree; `names` — is each camo face named after its own head |

## Scope

The camo schemes themselves — every pattern, its colours and its placement — were designed and
painted by Sk3y and Feldhobel. This tool only transfers that artwork onto additional heads.
