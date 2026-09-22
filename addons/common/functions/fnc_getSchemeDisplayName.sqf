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

private _scheme = [_schemeId] call FUNC(getScheme);
if (_scheme isEqualTo []) exitWith {""};

// already localized when the registry was read (see fnc_init.sqf)
_scheme select 3;
