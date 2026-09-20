# Common (`cfr_common`)

Shared logic behind applying and removing camouflage, used by both the dialog and the ACE self-actions.

The **Vanilla** camo scheme (Bohemia's own Marksmen DLC camo faces) is only available to players who own that DLC.

Face changes are synchronized across the network, so every player sees a unit's camouflage consistently.

A CBA setting, **Camo Wear-off Time (Minutes)** (under **Camouflage** in the settings menu), lets a mission maker or server admin make applied camo automatically fade back to the original face after a set number of minutes — simulating it wearing off from rain, sweat, or time. It's a slider from 0 to 240; 0 (the default) disables wear-off entirely, so camo lasts until manually removed. Wear-off only applies to player-controlled units; AI keep their camo until it's removed. To keep everyone from losing their camo at the same moment, each application's duration is randomized on a bell curve, typically within about 10 minutes either side of the configured time. A minute before it goes, the player gets a hint that their camouflage is starting to fade.

A second setting, **Will Camo Wash Off in Water** (a checkbox, on by default, shared by all clients), makes a player's camouflage wash off as soon as they swim or dive, returning their original face. Only player-controlled units are affected; AI keep their camo until it's removed. Turn it off to let camo survive swimming, for example in naval missions.
