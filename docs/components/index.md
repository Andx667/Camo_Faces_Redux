# Components

Camo Faces Redux follows the standard ACE-style addon layout: functionality is split across several `cfr_*` PBOs (addons), each with a single responsibility.

| Component | PBO | Purpose |
| --- | --- | --- |
| [Main](main.md) | `cfr_main` | Shared macros, mod metadata, and editor category |
| [Common](common.md) | `cfr_common` | Core logic: face lists, applying/removing camo |
| [Dialog](dialog.md) | `cfr_dialog` | The in-game UI for choosing and applying camo |
| [Faces](faces.md) | `cfr_faces` | The camouflaged face variants and textures |
| [Items](items.md) | `cfr_items` | The facepaint inventory items and their box |

Each addon has its own `script_component.hpp` (macro definitions), `CfgEventHandlers.hpp` (XEH hooks), and `functions/` folder, matching the [ACE3 coding guidelines](https://ace3.acemod.org/wiki/development/coding-guidelines) this project follows.
