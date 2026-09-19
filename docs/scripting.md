# Scripting & API

Mission makers and scripters can apply or remove camouflage directly from a script or the editor's init field, without going through the in-game dialog, ACE self-actions, or the Zeus context menu — and can react to camo being applied or removed by other means too. This page is the complete reference; no repository access needed.

!!! warning "Don't build the classname yourself"
    Some camo face mods let you build the target face classname yourself (e.g. `(face this) + "_some_suffix"`) and call `setFace` directly. That doesn't work here — this mod's camo classnames aren't a simple suffix on the base face classname. A plain `setFace` call also only changes the face locally: it won't sync to other players or survive a respawn. Always go through the functions below instead.

## Applying camouflage

```sqf
[this, "BWTarn"] call cfr_common_fnc_setCamo;
```

| Argument | Type | Description |
| --- | --- | --- |
| 0 | `OBJECT` | The unit to camouflage |
| 1 | `STRING` | The camo scheme id — see [Scheme IDs](#scheme-ids) below |

If the unit's current face doesn't have a variant under that scheme, nothing happens — no error, just a hint explaining why (on the calling machine).

If the **Camo Wear-off Time** CBA setting (see [Common](components/common.md)) is enabled, this also schedules automatic removal after the configured number of minutes — no extra argument needed, it just works the same as applying camo any other way. Only player-controlled units wear off; camo applied to an AI unit stays until removed, since AI can't reapply it themselves.

## Removing camouflage

```sqf
[this, face this] call cfr_common_fnc_unsetCamo;
```

| Argument | Type | Description |
| --- | --- | --- |
| 0 | `OBJECT` | The unit to remove camouflage from |
| 1 | `STRING` | The unit's current (camouflaged) face — usually just `face this` |

Restores whichever base face the given camo face pairs with.

## Scheme IDs

`"BWTarn"`, `"Black"`, `"BWStripes"`, `"Serbian"`, `"USStripes"`, `"USStains"`, `"USFlash"`, `"SnowStripes"`, or `"Vanilla"`, `"VanillaArid"`, `"VanillaLush"`, `"VanillaSemiArid"` (the Vanilla ones are only available with the Marksmen DLC — see [Installation](installation.md)).

Other addons can register further schemes and faces through config, which then work with every function on this page under their own ids — see [Extending the mod](https://github.com/Andx667/Camo_Faces_Redux/blob/main/addons/common/README.md#extending-the-mod) for addon authors.

## Reacting to camo changes

Other mods/missions can hook into two CBA events, raised only on the machine that actually applied or removed the camo (typically whichever client called the function above for its own unit):

| Event | Payload | Raised by |
| --- | --- | --- |
| `cfr_common_camoApplied` | `[unit, schemeId, oldFace, newFace]` | `cfr_common_fnc_setCamo`, after a camo face is applied |
| `cfr_common_camoRemoved` | `[unit, schemeId, oldFace, newFace]` | `cfr_common_fnc_unsetCamo`, after a camo face is removed |

```sqf
["cfr_common_camoApplied", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // ...
}] call CBA_fnc_addEventHandler;
```

Neither event fires on a rejected attempt (e.g. no matching variant for that scheme).
