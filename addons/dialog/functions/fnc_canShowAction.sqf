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

private _faceKnown = (
    _face in EGVAR(common,all_faces) ||
    _face in EGVAR(common,faces_bwtarn) ||
    _face in EGVAR(common,faces_black) ||
    _face in EGVAR(common,faces_bwstripes) ||
    _face in EGVAR(common,faces_serbian) ||
    _face in EGVAR(common,faces_usstripes) ||
    _face in EGVAR(common,faces_usstains) ||
    _face in EGVAR(common,faces_usflash)
);
private _hasItem = (
    QEGVAR(items,BW_Facepaint) in uniformItems _player ||
    QEGVAR(items,US_Facepaint) in uniformItems _player ||
    QEGVAR(items,Serbian_Facepaint) in uniformItems _player
);

if (_faceKnown && _hasItem) exitWith {true};

false;
