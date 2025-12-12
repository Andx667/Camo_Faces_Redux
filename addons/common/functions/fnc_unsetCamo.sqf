#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Face <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "camoface"] call cfr_common_fnc_unsetCamo
 *
 * Public: No
 */

params ["_unit","_face"];
TRACE_1("fnc_unsetCamo",_this);

private _ns = "";

//Das Abtarnen
if (_face in GVAR(faces_bwtarn)) then {
    _ns = [_face, 0, -14] call BIS_fnc_trimString; //_unit setface _ns;
    //[-2, {unit setface ns}] call CBA_fnc_globalExecute;
    [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
    _unit setVariable [QGVAR(face), _ns, true];
    hint "Tarnung abgelegt";
} else {
    if (_face in GVAR(faces_black)) then {
            _ns = [_face, 0, -13] call BIS_fnc_trimString; //_unit setface _ns;
            //[-2, {unit setface ns}] call CBA_fnc_globalExecute;
        [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
            _unit setVariable [QGVAR(face), _ns, true];
            hint "Tarnung abgelegt";
    } else {
        if (_face in GVAR(faces_bwstripes) || _face in GVAR(faces_usstripe)) then {
                _ns = [_face, 0, -17] call BIS_fnc_trimString; //_unit setface _ns;
                [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
                _unit setVariable [QGVAR(face), _ns, true];
                //[-2, {unit setface ns}] call CBA_fnc_globalExecute;
                hint "Tarnung abgelegt";
        } else {
            if (_face in GVAR(faces_serbian) || _face in GVAR(faces_usflash)) then {
                _ns = [_face, 0, -15] call BIS_fnc_trimString; //_unit setface _ns;
            [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
                _unit setVariable [QGVAR(face), _ns, true];
                //[-2, {unit setface ns}] call CBA_fnc_globalExecute;
                hint "Tarnung abgelegt";
            } else {
                if (_face in GVAR(faces_usstains)) then {
                    _ns = [_face, 0, -16] call BIS_fnc_trimString; //_unit setface _ns;
                    [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
                    _unit setVariable [QGVAR(face), _ns, true];
                    //[-2, {unit setface ns}] call CBA_fnc_globalExecute;
                    hint "Tarnung abgelegt";
                };
            };
        };
    };
};
