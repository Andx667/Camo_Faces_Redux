#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * ACE self-action statement for the "Camo Faces" menu entry (CfgVehicles.hpp, gated by
 * fnc_canShowAction.sqf): opens the dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call cfr_dialog_fnc_startDialog
 *
 * Public: No
 */

params [];
TRACE_1("fnc_startDialog",_this);

createDialog QGVAR(Dialog);
