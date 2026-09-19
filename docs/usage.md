# Usage

## Applying camouflage

1. Equip one of the facepaint items (BW, Serbian, or US Facepaint) in your uniform. These are stocked in the **Box of Facepaint** placed by mission makers, or can be added to a loadout directly.
2. Remove your helmet, goggles, and night vision — camouflage can only be applied to a bare face.
3. Open your ACE self-interaction menu and select **Camo Faces** to open the camouflage dialog.
4. Pick a country/scheme from the left list, then a specific camo pattern from the right list.
5. Click the three layer buttons in order to build up the camouflage. Each layer has a short delay before the next one unlocks; the final layer applies the chosen face.

## Painting a teammate

You can paint a friendly unit's face too - a player or an AI teammate standing next to you. Have facepaint in your own uniform, make sure they've taken off their helmet, goggles and night vision, open the ACE interaction menu on them and pick **Interactions -> Paint Face**, then the pattern. Stay next to them until the three layers are done; if they walk off or put headgear back on, it's cancelled. They'll see a message that you painted them. (The pattern entries are greyed out while their headgear is still on.)

## Removing camouflage

Open the dialog again (the self-action also shows while camo is currently applied) and use the **remove camo** button to revert to your original face.

To wipe camo off a friendly unit's face, open the ACE interaction menu on them and pick **Interactions -> Clean Face**. This needs no facepaint item.

Mission makers can switch painting other units off with the **Allow Painting Other Units** setting.

## Notes

- The dialog shows a live mirror preview of your face while it's open.
- Your applied camo face is remembered per-unit and reapplied automatically on respawn.
- Camouflage covers the base game's faces plus those added by Apex, Contact, Laws of War, Tac-Ops Mission Pack and Tanks. Most DLC faces only show up if you own that DLC, so which patterns you're offered depends on the face you're wearing — see [Faces](components/faces.md).
- If the mission maker or server admin has enabled the **Camo Wear-off Time** setting, applied camo automatically fades back to your original face after that many minutes, simulating it wearing off from rain, sweat, or time — see [Common](components/common.md).

## As Zeus (optional)

If [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631) is also loaded, right-clicking a unit brings up a **Camouflage** entry in the context menu — see [Zeus Enhanced Compat](components/compat_zen.md).

## As a mission maker or scripter

Camo Faces Redux can also be applied/removed directly from a script or the editor's init field, and other mods/missions can react to camo changes — see [Scripting & API](scripting.md).
