#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Returns the camo schemes available under a given country/group selection (see
 * fnc_getCountryOptions.sqf) that the player's current base face actually has a variant for, as
 * [displayName, schemeId] pairs for the dialog's camo-pattern listbox. Only offers options while
 * the player's face is a known, un-camo'd base face - switching camo schemes directly isn't
 * supported, the current one has to be removed first.
 *
 * Arguments:
 * 0: Selected Country/Group <STRING>
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
    // camo_usstains, camo_usflash, camo_vanilla, camo_serbian_short, camo_vanilla_short,
    // camo_eyeblack); this is a false positive, not a real missing key.
    private _strPrefix = QUOTE(DOUBLES(STR,ADDON)) + "_";

    // The notebook's pattern list (this function) is narrow, so a couple of schemes get a shorter
    // label here than their shared GVAR(schemes) stringKey - which stays unshortened for other
    // consumers (ACE self-actions, ZEN context menu) that have more room to display it.
    private _shortStringKeys = [["Serbian", "camo_serbian_short"], ["Vanilla", "camo_vanilla_short"]];

    // "Black" isn't tied to one specific item like the others - it's offered under every country
    // selection so it's reachable with whichever facepaint item the player actually has equipped
    private _schemeIds = switch (_select) do {
        case "bw_select": { ["BWTarn", "BWStripes", "Black"] };
        case "serbian_select": { ["Serbian", "Black"] };
        case "us_select": { ["USStripes", "USStains", "USFlash", "Black"] };
        case "vanilla_select": { ["Vanilla"] };
        // PROTOTYPE: EyeBlack - its own category (see fnc_getCountryOptions.sqf), only one color so
        // no "Black" fallback needed alongside it like the military categories above
        case "eyeblack_select": { ["EyeBlack"] };
        default { [] };
    };

    {
        private _schemeId = _x;
        private _schemeIdx = GVAR(schemes) findIf {(_x select 0) == _schemeId};
        if (_schemeIdx != -1) then {
            (GVAR(schemes) select _schemeIdx) params ["", "_pairs", "", "_stringKey"];

            private _shortKeyIdx = _shortStringKeys findIf {(_x select 0) == _schemeId};
            if (_shortKeyIdx != -1) then {_stringKey = (_shortStringKeys select _shortKeyIdx) select 1;};

            if ((_pairs findIf {(_x select 0) == _face}) != -1) then {
                _selected pushBack [localize (_strPrefix + _stringKey), _schemeId];
            };
        };
    } forEach _schemeIds;
};

//return value
_selected;
