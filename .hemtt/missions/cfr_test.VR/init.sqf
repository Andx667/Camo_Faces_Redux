// Test loadout for both riflemen: nothing on the head (headgear, goggles and NVG all block camo) and
// every facepaint stick in the uniform. Faces are set to registered base faces, so the camo schemes
// are offered whatever the profile's own face is.
private _sticks = [
    "cfr_items_BW_FacepaintStick",
    "cfr_items_US_FacepaintStick",
    "cfr_items_Serbian_FacepaintStick",
    "cfr_items_SnowStripes_FacepaintStick"
];
private _faces = createHashMapFromArray [
    ["cfr_test_1", "WhiteHead_02"],
    ["cfr_test_2", "AfricanHead_02"]
];

{
    private _unit = _x;
    if (local _unit) then {
        removeHeadgear _unit;
        removeGoggles _unit;
        _unit unlinkItem hmd _unit;

        {
            _unit addItemToUniform _x;
        } forEach _sticks;

        [_unit, _faces get vehicleVarName _unit] remoteExec ["setFace", 0, _unit];
    };
} forEach (allUnits select {(vehicleVarName _x) in ["cfr_test_1", "cfr_test_2"]});
