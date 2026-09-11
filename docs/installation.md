# Installation

## Requirements

Camo Faces Redux depends on:

- [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest)
- [ACE3](https://github.com/acemod/ACE3)

Both must be loaded **before** Camo Faces Redux.

Optionally, [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) (ZEN) enables a Zeus context-menu integration (see [Usage](usage.md)) — no configuration needed, it activates automatically if ZEN is also loaded.

## Players

1. Subscribe to the mod on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=MOD_ID), or download a release from the [Releases](https://github.com/Andx667/CamoFacesRedux/releases) page.
2. Make sure CBA_A3 and ACE3 are also installed and enabled.
3. Enable **Camo Faces Redux**, CBA_A3, and ACE3 in your mod launcher.

## Server owners

Add the mod's PBO folder alongside CBA_A3 and ACE3 in your server's mod line, keeping the same load order (CBA_A3 → ACE3 → Camo Faces Redux).

## Building from source

Camo Faces Redux is built with [HEMTT](https://hemtt.dev/):

```cmd
winget install hemtt
```

From the repository root:

```cmd
hemtt build
```

Run `hemtt check` to validate configs, scripts, and stringtables without producing a build.
