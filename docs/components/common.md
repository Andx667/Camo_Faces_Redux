# Common (`cfr_common`)

Shared logic behind applying and removing camouflage, used by both the dialog and the ACE self-actions.

The **Vanilla** camo scheme (Bohemia's own Marksmen DLC camo faces) is only available to players who own that DLC.

Face changes are synchronized across the network, so every player sees a unit's camouflage consistently.

A CBA setting, **Camo Wear-off Time (Minutes)** (under **Camouflage** in the settings menu), lets a mission maker or server admin make applied camo automatically fade back to the original face after a set number of minutes — simulating it wearing off from rain, sweat, or time. It's a slider from 0 to 240; 0 (the default) disables wear-off entirely, so camo lasts until manually removed.
