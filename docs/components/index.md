# Components

Camo Faces Redux follows the standard ACE-style addon layout: functionality is split across several `cfr_*` PBOs (addons), each with a single responsibility.

| Component | PBO | Purpose |
| --- | --- | --- |
| [Main](main.md) | `cfr_main` | Shared macros, mod metadata, and editor category |
| [Common](common.md) | `cfr_common` | Core logic: face lists, applying/removing camo |
| [Dialog](dialog.md) | `cfr_dialog` | The in-game UI for choosing and applying camo |
| [Faces](faces.md) | `cfr_faces` | The camouflaged face variants and textures |
| [Items](items.md) | `cfr_items` | The facepaint inventory items and their box |
| [Zeus Enhanced Compat](compat_zen.md) | `cfr_compat_zen` | Optional: lets a Zeus curator apply/remove camo from ZEN's context menu |
