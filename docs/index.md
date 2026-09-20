# Camo Faces Redux

![Camo Faces Redux Logo](assets/logo.png){ width="240" }

**Camo Faces Redux** (CFR) gives players the possibility to camouflage their faces during Arma 3 missions. It builds on the previous work by Sk3y and Feldhobel in the mod [Camofaces](https://steamcommunity.com/sharedfiles/filedetails/?id=346665985).

The project is entirely open-source and any contributions are welcome — see [Contributing](contributing.md).

!!! info "Requirements"
    Camo Faces Redux requires the latest versions of [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest) and [ACE3](https://github.com/acemod/ACE3).

## Core Features

- Adds camo face variants of the base game's faces, and of those added by Apex, Contact, Laws of War, Tac-Ops Mission Pack and Tanks, in multiple schemes:
    - Bundeswehr Camouflage
    - Bundeswehr Stripes
    - Serbian Camouflage
    - Black (Night)
    - US Stripes
    - US Flash
    - US Stains
    - Snow Stripes
    - Bohemia's own Marksmen DLC camo faces (if you own the DLC)
- Adds consumable facepaint sticks (10 uses each) needed to camouflage your face, and a supply box stocked with them
- Camouflage yourself through a dialog or ACE self-actions, or [paint and clean a teammate's face](usage.md#painting-a-teammate)
- Optional wear-off of applied camo after a configurable time, with a warning shortly before it goes
- Optional [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) integration for applying/removing camo as a curator
- Other addons can register their own faces and camo schemes through config - see [Scripting & API](scripting.md#scheme-ids)
- Translated into every language Arma 3 ships (see [Contributing](contributing.md#translations))

## Getting Started

- [Installation](installation.md) — how to get the mod running alongside CBA and ACE3
- [Usage](usage.md) — how to apply and remove camouflage in-game
- [Scripting & API](scripting.md) — for mission makers and scripters
- [Components](components/index.md) — a tour of the addons that make up the mod
