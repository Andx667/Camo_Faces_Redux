#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Cleans up the mirror camera created by fnc_initDialog when the dialog closes.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call cfr_dialog_fnc_closeDialog
 *
 * Public: No
 */

params [];
TRACE_1("fnc_closeDialog",_this);

if (!isNil QGVAR(mirrorCam)) then {
	deleteVehicle GVAR(mirrorCam);
	GVAR(mirrorCam) = nil;
};
