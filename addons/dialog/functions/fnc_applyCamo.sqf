#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * Drives one step of the dialog's layered "apply camo" button sequence (see Dialog.hpp /
 * fnc_initDialog.sqf). Layers 1 and 2 just hint and, after a short non-blocking delay, unlock the
 * next layer's button; layer 3 calls cfr_common's fnc_setCamo with the pattern selected in the
 * camo-pattern listbox, then locks all three buttons again.
 *
 * Arguments:
 * 0: Level <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1] call cfr_dialog_fnc_applyCamo
 *
 * Public: No
 */

params ["_level"];
TRACE_1("fnc_applyCamo",_this);

disableSerialization;

// ace_common_fnc_progressBar unconditionally calls "closeDialog 0" before drawing its own bar,
// regardless of its "_dialog" argument - it cannot be used while GVAR(Dialog) stays open, so the
// dialog flow keeps its original blind CBA_fnc_waitAndExecute delay (button "action" code runs
// unscheduled, so a blocking sleep is not legal here) instead of a visible progress bar.
switch (_level) do {
    case 1: {
        hint (localize LSTRING(applyingLayer1));
        [{
            ((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER2) ctrlEnable true;
            hint (localize LSTRING(layerDone));
        }, [], 2] call CBA_fnc_waitAndExecute;
    };

    case 2: {
        hint (localize LSTRING(applyingLayer2));
        [{
            ((findDisplay IDD_DIALOG) displayCtrl IDC_BUTTON_LAYER3) ctrlEnable true;
            hint (localize LSTRING(layerDone));
        }, [], 2] call CBA_fnc_waitAndExecute;
    };

    case 3: {
        hint (localize LSTRING(applyingLayer3));
        [{
            private _display = findDisplay IDD_DIALOG;
            private _lbCamo = _display displayCtrl IDC_LISTBOX_CAMOFACE;
            private _scheme = _lbCamo lbData (lbCurSel _lbCamo);

            private _usesText = [player, player, _scheme] call FUNC(finishApplyCamo);
            // the uses left go on top of fnc_setCamo's own "camouflage applied" hint
            if (!(_usesText isEqualTo false) && {_usesText != ""}) then {
                hint ((localize ELSTRING(common,camoApplied)) + "\n" + _usesText);
            };

            {(_display displayCtrl _x) ctrlEnable false} forEach [IDC_BUTTON_LAYER1, IDC_BUTTON_LAYER2, IDC_BUTTON_LAYER3];
        }, [], 2] call CBA_fnc_waitAndExecute;
    };
};
