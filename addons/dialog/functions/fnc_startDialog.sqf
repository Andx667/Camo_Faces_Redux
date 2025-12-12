#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Opens the camouflage application dialog.
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
