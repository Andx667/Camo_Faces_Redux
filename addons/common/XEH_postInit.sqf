#include "script_component.hpp"

[QGVAR(setFace), {
	params ["_unit", "_face"];
	_unit setFace _face;
}] call CBA_fnc_addEventHandler;

call FUNC(init);
