#include "..\script_component.hpp"
/*
 * Authors: Andx
 * Returns the localized display name for a camo scheme.
 *
 * Arguments:
 * 0: Camo scheme id, e.g. "BWTarn" or "Vanilla" <STRING>
 *
 * Return Value:
 * Localized display name, or "" if the scheme id doesn't exist <STRING>
 *
 * Example:
 * ["BWTarn"] call cfr_common_fnc_getSchemeDisplayName
 *
 * Public: No
 */

params ["_schemeId"];
TRACE_1("fnc_getSchemeDisplayName",_this);

private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
if (_schemeIdx == -1) exitWith {""};

(GVAR(schemes) select _schemeIdx) params ["", "", "", "_stringKey"];

// see fnc_getCamoOptions.sqf for why this can't be a compile-time LSTRING(x) call
private _strPrefix = QUOTE(DOUBLES(STR,ADDON)) + "_";

localize (_strPrefix + _stringKey);
