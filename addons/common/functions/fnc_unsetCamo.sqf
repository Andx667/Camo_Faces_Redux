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
private _suffix = "";

// Determine which suffix to remove
if (_face in GVAR(faces_bwtarn)) then {
    _suffix = "_cfaces_BWTarn";
} else {
    if (_face in GVAR(faces_black)) then {
        _suffix = "_cfaces_Black";
    } else {
        if (_face in GVAR(faces_bwstripes) || _face in GVAR(faces_usstripes)) then {
            _suffix = "_cfaces_BWStripes";
            if (_face in GVAR(faces_usstripes)) then {
                _suffix = "_cfaces_USStripes";
            };
        } else {
            if (_face in GVAR(faces_serbian)) then {
                _suffix = "_cfaces_Serbian";
            } else {
                if (_face in GVAR(faces_usflash)) then {
                    _suffix = "_cfaces_USFlash";
                } else {
                    if (_face in GVAR(faces_usstains)) then {
                        _suffix = "_cfaces_USStains";
                    };
                };
            };
        };
    };
};

// Remove the suffix
if (_suffix != "") then {
    _ns = [_face, 0, -(count _suffix)] call BIS_fnc_trimString;
    [[_unit,_ns], "setFace", true, false] call BIS_fnc_mp;
    _unit setVariable [QGVAR(face), _ns, true];
    hint "Tarnung abgelegt";
};
