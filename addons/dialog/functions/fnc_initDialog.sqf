#include "..\script_component.hpp"
/*
 * Authors: Andx, Sk3y
 * onload handler for GVAR(Dialog) (Dialog.hpp). Sets the day/night notepad textures, disables the
 * 3 apply-layer buttons, colors the helmet/goggles/NV indicators based on what the player currently
 * has equipped, populates the country listbox via cfr_common's fnc_getCountryOptions, and
 * (re)creates the mirror camera that live-previews the player's face - cleaned up again by
 * fnc_closeDialog.sqf on onunload.
 *
 * Arguments:
 * 0: DISPLAY <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [my_display] call cfr_dialog_fnc_initDialog
 *
 * Public: No
 */

params ["_display"];
TRACE_1("fnc_initDialog",_this);

disableSerialization;

// set texture for day or night
private _hour = date select 3;
private _box = _display displayCtrl IDC_PICTURE_BOX;
private _notepad = _display displayCtrl IDC_PICTURE_NOTEPAD;

if (_hour > 21 || _hour < 6) then {
    _box ctrlSetText QPATHTOF2(data\UI\box_night.paa);
    _notepad ctrlSetText QPATHTOF2(data\UI\notepad_night.paa);

} else {
    _box ctrlSetText QPATHTOF2(data\UI\box.paa);
    _notepad ctrlSetText QPATHTOF2(data\UI\notepad.paa);
};

// deactivate button
private _button1 = _display displayCtrl IDC_BUTTON_LAYER1;
private _button2 = _display displayCtrl IDC_BUTTON_LAYER2;
private _button3 = _display displayCtrl IDC_BUTTON_LAYER3;

_button1 ctrlEnable false; // as long as not all items are unequipped and options are choosen
_button2 ctrlEnable false; // as long as not all items are unequipped and options are choosen
_button3 ctrlEnable false; // as long as not all items are unequipped and options are choosen

/*
    picture color and button function
*/
// controls for pictures
private _backHelmet = _display displayCtrl IDC_TEXT_HELMET;
private _backGoggles = _display displayCtrl IDC_TEXT_GOGGLES;
private _backNV = _display displayCtrl IDC_TEXT_NV;

// colors
private _red = [1, 0, 0, 0.6];
private _green = [0, 1, 0, 0.6];

// check if player has helmet, googles, nv equipped
if (headgear player == "") then {
    _backHelmet ctrlSetBackgroundColor _green;
    GVAR(hasHelmet) = false; //ToDo Maybe these should not be global variables and instead be set on the unit
} else {
    _backHelmet ctrlSetBackgroundColor _red;
    GVAR(hasHelmet) = true;
};

if (goggles player == "") then {
    _backGoggles ctrlSetBackgroundColor _green;
    GVAR(hasGoggles) = false;
} else {
    _backGoggles ctrlSetBackgroundColor _red;
    GVAR(hasGoggles) = true;
};

if (hmd player == "") then {
    _backNV ctrlSetBackgroundColor _green;
    GVAR(hasNV) = false;
} else {
    _backNV ctrlSetBackgroundColor _red;
    GVAR(hasNV) = true;
};

/*
    fill first listbox
*/
private _listBox_Side = _display displayCtrl IDC_LISTBOX_COUNTRY;
lbClear _listBox_Side;

private _camolist = [player] call EFUNC(common,getCountryOptions);

// proof return value
// no option
if (count _camolist == 0) then {
    _listBox_Side lbAdd (localize LSTRING(noOption));
} else {
    // fill notepad with options returned by function
    {
        // add text
        _listBox_Side lbAdd (_x select 0);
        // add hidden data
        _listBox_Side lbSetData [_forEachIndex, (_x select 1)];
    } forEach _camolist;
};

// initialize mirror - create camera and stream to the render-to-texture surface
if (!isNil QGVAR(mirrorCam)) then {
    deleteVehicle GVAR(mirrorCam);
};

GVAR(mirrorCam) = "camera" camCreate [0,0,0];
GVAR(mirrorCam) cameraEffect ["Internal", "Back", "camofacesmirror"];

// attach to the player's head so it mirrors the current face
GVAR(mirrorCam) attachTo [player, [-0.05,0.4,0.1], "head"];
// vectorDir/vectorUp: face the camera back at the player
GVAR(mirrorCam) setVectorDirAndUp [[0,-1,0], [0,0,1]];
// zoom in slightly so the face fills the mirror
GVAR(mirrorCam) camSetFov 0.5;
