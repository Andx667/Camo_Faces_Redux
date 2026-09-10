#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [player] call cfr_dialog_fnc_canShowAction
 *
 * Public: No
 */

params ["_player"];
TRACE_1("fnc_canShowAction",_this);

private _face = face _player;

if (
    (
        _face in GVAR(all_faces) ||
        _face in GVAR(faces_bwtarn) ||
        _face in GVAR(faces_black) ||
        _face in GVAR(faces_bwstripes) ||
        _face in GVAR(faces_serbian) ||
        _face in GVAR(faces_usstripes) ||
        _face in GVAR(faces_usstains) ||
        _face in GVAR(faces_usflash)
    ) && (
        EGVAR(items,BW_Facepaint) in uniformItems _player ||
        EGVAR(items,US_Facepaint) in uniformItems _player ||
        EGVAR(items,Serbian_Facepaint) in uniformItems _player
    )
) exitWith {true};

false;
