#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Applies a camo scheme directly via ACE self-action, replicating the dialog's 3-layer progressive
 * feel (fnc_applyCamo) without any dialog UI - each step is 2 seconds apart.
 *
 * Arguments:
 * 0: Camo scheme suffix, e.g. "BWTarn" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["BWTarn"] call cfr_dialog_fnc_applyCamoAction
 *
 * Public: No
 */

params ["_camo"];
TRACE_1("fnc_applyCamoAction",_this);

hint (localize LSTRING(applyingLayer1));
[{
    params ["_camo"];
    hint (localize LSTRING(applyingLayer2));
    [{
        params ["_camo"];
        hint (localize LSTRING(applyingLayer3));
        [{
            params ["_camo"];
            [ACE_player, _camo] call EFUNC(common,setCamo);
        }, [_camo], 2] call CBA_fnc_waitAndExecute;
    }, [_camo], 2] call CBA_fnc_waitAndExecute;
}, [_camo], 2] call CBA_fnc_waitAndExecute;
