#include "..\script_component.hpp"
/*
 * Author: Andx, Sk3y
 * Initializes the camouflage application dialog with controls and listboxes.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call cfr_dialog_fnc_initDialog
 *
 * Public: No
 */

params ["_display"];
TRACE_1("fnc_initDialog",_this);

disableSerialization;

// set texture for day or night
private _hour = date select 3;
private _box = _display displayCtrl 4961;
private _notepad = _display displayCtrl 4966;

//ToDo Fix
if (_hour > 21 || _hour < 6) then {
	_box ctrlSetText QPATHTOF(data\UI\box_night.paa);
	_notepad ctrlSetText QPATHTOF(data\UI\notepad_night.paa);

} else {
	_box ctrlSetText QPATHTOF(data\UI\box.paa);
	_notepad ctrlSetText QPATHTOF(data\UI\notepad.paa);
};

// deactivate button
private _button1 = _display displayCtrl 5362;
private _button2 = _display displayCtrl 5363;
private _button3 = _display displayCtrl 5364;

_button1 ctrlEnable false; // as long as not all items are unequipped and options are choosen
_button2 ctrlEnable false; // as long as not all items are unequipped and options are choosen
_button3 ctrlEnable false; // as long as not all items are unequipped and options are choosen

/*
	picture color and button function
*/
// controls for pictures
private _backHelmet = _display displayCtrl 4862;
private _backGoggles = _display displayCtrl 4863;
private _backNV = _display displayCtrl 4864;

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
private _listBox_Side = _display displayCtrl 5262;
lbClear _listBox_Side;

private _camolist = call EFUNC(common,getCountryOptions);

// proof return value
// no option
if (count _camolist == 0) then {
	_listBox_Side lbAdd (LSTRING(noOption));
} else {
	// fill notepad with options returned by function
	{
		// add text
		_listBox_Side lbAdd (_x select 0);
		// add hidden data
		_listBox_Side lbSetData [_forEachIndex, (_x select 1)];
	} forEach _camolist;
};

// initialize mirror
/* create camera and stream to render surface */

cam = "camera" camCreate [0,0,0];
cam cameraEffect ["Internal", "Back", "camofacesmirror"];

/* attach cam to gunner cam position */
//cam attachTo [uav, [0,0,0], "PiP0_pos"];
/*
Attaches an object to another object.
The offset is applied to the object center unless a memory point is provided.
If no offset is specified, the offset used will be the current relative positioning of
objects against each other.
object1 attachTo [object2, offset, memPoint]
    object1: Object - object to attach
    [object2, offset, memPoint]: Array
    object2: Object - object to attach to
    offset: (optional): Array - format Position
    memPoint: (optional): String - see ArmA: Selection Translations for czech selections names
*/
cam attachTo [player, [-0.05,0.4,0.1],"head"];
/*
Sets orientation of an object.
The command takes 2 vector arrays, one for vectorDir and one for vectorUp.
Default object orientation will always have vectorDir pointing forward (North)
along Y axis and vectorUp pointing up along Z axis - [[0,1,0],[0,0,1]],
as shown on the diagram below.
When attaching object to an object the axes are relative to the object that gets the attachment.
If it is player object for example, then X goes from left to right, Y goes from back to front, and Z goes from down up.
The setDir command is incompatible with setVectorDirAndUp and should not be used together on the same object.
Using setVectorDirAndUp alone should be sufficient for any orientation.
In Multiplayer, setVectorDirAndUp must be executed on the machine where the object it applied to is local.
*/
cam setVectorDirAndUp [[0,-1,0], [0,0,1]]; // zwei Vektoren, einer für die Richtung, der andere für die Aufstellung

/* make it zoom in a little */
/*
Set the zoom level (Field Of View) of the given camera.
The zoom level is from 0.01 for the nearest and 2 for the furthest zoom value, with a default zoom level of 0.7
*/
cam camSetFov 0.5;
