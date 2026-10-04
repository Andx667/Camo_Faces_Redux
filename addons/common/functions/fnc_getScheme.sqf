#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Looks up a camo scheme's GVAR(schemes) row by its id. Shared by every consumer that needs to look
 * a scheme up by id (see fnc_init.sqf for the row layout) instead of each re-walking GVAR(schemes)
 * with its own findIf.
 *
 * Arguments:
 * 0: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
 *
 * Return Value:
 * The scheme's GVAR(schemes) row, or [] if the scheme id doesn't exist <ARRAY>
 *
 * Example:
 * ["BWTarn"] call cfr_common_fnc_getScheme
 *
 * Public: No
 */

params [["_schemeId", "", [""]]];

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
if (_schemeIdx == -1) exitWith {[]};
GVAR(schemes) select _schemeIdx;
