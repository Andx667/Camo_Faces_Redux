# API

Camo Faces Redux exposes two [CBA events](https://cba-team.github.io/wiki/events/) that other mods and missions can listen to, to react whenever a unit's camo face paint is applied or removed — for example, to hook in a detection/camouflage-bonus system, log it, or drive a UI element elsewhere.

Both events require [CBA_A3](https://github.com/CBATeam/CBA_A3) and are broadcast with `CBA_fnc_globalEvent`, exactly like this mod's own internal `cfr_common_setFace` event — they fire on **every** machine (server and all clients), regardless of which machine actually triggered the change, so a listener added anywhere will see every apply/remove in the mission.

## `cfr_common_camoApplied`

Raised after a camo face paint is successfully applied to a unit (via either the dialog or an ACE self-action, after all 3 layers complete).

```sqf
["cfr_common_camoApplied", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // ...
}] call CBA_fnc_addEventHandler;
```

| # | Name | Type | Description |
| --- | --- | --- | --- |
| 0 | `_unit` | `OBJECT` | The unit whose face changed |
| 1 | `_schemeId` | `STRING` | The camo scheme that was applied, e.g. `"BWTarn"`, `"Serbian"`, `"Vanilla"` |
| 2 | `_oldFace` | `STRING` | The unit's base (un-camo'd) `CfgFaces` classname before the change |
| 3 | `_newFace` | `STRING` | The camo `CfgFaces` classname now applied |

## `cfr_common_camoRemoved`

Raised after camo face paint is successfully removed from a unit, restoring its base face.

```sqf
["cfr_common_camoRemoved", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // ...
}] call CBA_fnc_addEventHandler;
```

| # | Name | Type | Description |
| --- | --- | --- | --- |
| 0 | `_unit` | `OBJECT` | The unit whose face changed |
| 1 | `_schemeId` | `STRING` | The camo scheme that was removed, e.g. `"BWTarn"`, `"Serbian"`, `"Vanilla"` |
| 2 | `_oldFace` | `STRING` | The camo `CfgFaces` classname the unit had before the change |
| 3 | `_newFace` | `STRING` | The unit's base (un-camo'd) `CfgFaces` classname now restored |

## Notes

- Neither event fires on a rejected attempt (e.g. missing item, headgear still on, wrong base face) — only on an actual, successful face change.
- Both events share the same `[unit, schemeId, oldFace, newFace]` shape, so a single handler can subscribe to both if only the direction (`_newFace`'s meaning) matters:

```sqf
["cfr_common_camoApplied", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // unit now wearing _newFace
}] call CBA_fnc_addEventHandler;

["cfr_common_camoRemoved", {
    params ["_unit", "_schemeId", "_oldFace", "_newFace"];
    // unit back to its base face, _newFace
}] call CBA_fnc_addEventHandler;
```

- `_schemeId` values correspond to the `schemeId` column of `cfr_common`'s internal `GVAR(schemes)` table — currently `"BWTarn"`, `"Black"`, `"BWStripes"`, `"Serbian"`, `"USStripes"`, `"USStains"`, `"USFlash"`, and (only if the Marksmen DLC is available) `"Vanilla"`.
