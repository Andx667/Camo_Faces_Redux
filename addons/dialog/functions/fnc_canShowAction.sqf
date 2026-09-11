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

private _faceKnown = (_face in EGVAR(common,all_faces)) || ([_face] call EFUNC(common,isCamoFace));
private _hasItem = (GVAR(itemClasses) findIf {_x in uniformItems _player}) != -1;

if (_faceKnown && _hasItem) exitWith {true};

false;
