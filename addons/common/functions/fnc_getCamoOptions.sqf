#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Description.
 *
 * Arguments:
 * 0: Selected Camo Scheme <STRING>
 *
 * Return Value:
 * List of available Camos <ARRAY>
 *
 * Example:
 * ["bw_select"] call cfr_common_fnc_getCamoOptions
 *
 * Public: No
 */

params ["_select"];
TRACE_1("fnc_getCamoOptions",_this);

private _selected = [];
private _face = face player;

// only offer options while the player's current face is an un-camo'd base face - switching camo
// schemes directly isn't supported, remove the current one first (matches existing behavior)
if (_face in GVAR(all_faces)) then {
	// "STR_cfr_common_" - built once via the same DOUBLES/QUOTE macros LSTRING uses internally, so a
	// scheme's stringKey can be localized without a compile-time-fixed LSTRING(x) call. HEMTT's
	// stringtable linter can't trace this concatenation back to a static key and will warn about it
	// (L-L02M, "missing keys in use") - every stringKey in GVAR(schemes) is a real, verified key in
	// stringtable.xml (camo_bwtarn, camo_black, camo_bwstripes, camo_serbian, camo_usstripes,
	// camo_usstains, camo_usflash, camo_vanilla); this is a false positive, not a real missing key.
	private _strPrefix = QUOTE(DOUBLES(STR,ADDON)) + "_";

	private _schemeIds = switch (_select) do {
		case "bw_select": { ["BWTarn", "Black", "BWStripes"] };
		case "serbian_select": { ["Serbian"] };
		case "us_select": { ["USStripes", "USStains", "USFlash"] };
		case "vanilla_select": { ["Vanilla"] };
		default { [] };
	};

	{
		private _schemeId = _x;
		private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
		if (_schemeIdx != -1) then {
			(GVAR(schemes) select _schemeIdx) params ["", "_pairs", "", "_stringKey"];
			if ((_pairs findIf {(_x select 0) == _face}) != -1) then {
				_selected pushBack [localize (_strPrefix + _stringKey), _schemeId];
			};
		};
	} forEach _schemeIds;
};

//return value
_selected;
