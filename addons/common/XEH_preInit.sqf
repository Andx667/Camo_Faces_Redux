#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Builds GVAR(schemes) here (preInit) rather than postInit specifically so it exists before any
// mission entity - and therefore any unit's init field - runs. See fnc_init.sqf for the full reason.
call FUNC(init);

// Hook into CBA's Extended Loadout framework (CBA_fnc_getLoadout/CBA_fnc_setLoadout) so a saved
// camo face rides along whenever something exports/imports a loadout through that framework (e.g.
// ACE Arsenal's loadout export, or a mission's own loadout persistence) - GVAR(face) is otherwise
// only preserved via XEH_postInit's unit-variable + reapply loop, which doesn't cover that round
// trip. Registered here rather than postInit - like ACE3's hearing/gunbag components do for their
// own CBA_loadoutGet/Set hooks - since registration itself needs nothing postInit provides (no
// units need to exist yet), so registering as early as possible avoids racing a mission's own
// init.sqf, which isn't guaranteed to run after every addon's postInit has finished.
// Both events are CBA_fnc_localEvent, same as fnc_setCamo/fnc_unsetCamo's public API events - they
// only fire on whichever machine actually calls CBA_fnc_getLoadout/CBA_fnc_setLoadout.
["CBA_loadoutGet", {
    params ["_unit", "", "_extendedInfo"];
    private _face = _unit getVariable [QGVAR(face), ""];
    if (_face != "") then {
        _extendedInfo set [QGVAR(face), _face];
    };
}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "", "_extendedInfo"];
    private _face = _extendedInfo getOrDefault [QGVAR(face), ""];
    if (_face != "") then {
        // networked the same way fnc_setCamo/fnc_unsetCamo apply a face, rather than calling
        // setFace directly, so every client's view of the unit stays in sync
        [QGVAR(setFace), [_unit, _face]] call CBA_fnc_globalEvent;
        _unit setVariable [QGVAR(face), _face, true];
    };
}] call CBA_fnc_addEventHandler;

// private _category = [QUOTE(MOD_NAME), LLSTRING(displayName)];

// #include "initSettings.inc.sqf"
// #include "initKeybinds.inc.sqf"
