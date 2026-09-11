class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions  {
            class GVAR(SelfAction) {
                displayName = CSTRING(Action);
                condition = QUOTE(([ACE_player] call FUNC(canShowAction)) && {!GVAR(useAceActions)});
                statement = QUOTE(call FUNC(startDialog));
                showDisabled = 0;
                priority = 4;
                icon = QPATHTOEF(common,data\UI\Icon_camoon_ca.paa);
            };
            class GVAR(SelfActionRoot) {
                displayName = CSTRING(Action);
                condition = QUOTE(([ACE_player] call FUNC(canShowAction)) && {GVAR(useAceActions)});
                statement = "";
                showDisabled = 0;
                priority = 4;
                icon = QPATHTOEF(common,data\UI\Icon_camoon_ca.paa);

                class GVAR(Action_BWTarn) {
                    displayName = ECSTRING(common,camo_bwtarn);
                    condition = QUOTE(['BWTarn'] call FUNC(canApplyScheme));
                    statement = QUOTE(['BWTarn'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_bwtarn_ca.paa);
                };
                class GVAR(Action_Black) {
                    displayName = ECSTRING(common,camo_black);
                    condition = QUOTE(['Black'] call FUNC(canApplyScheme));
                    statement = QUOTE(['Black'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_black_ca.paa);
                };
                class GVAR(Action_BWStripes) {
                    displayName = ECSTRING(common,camo_bwstripes);
                    condition = QUOTE(['BWStripes'] call FUNC(canApplyScheme));
                    statement = QUOTE(['BWStripes'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_bwstripes_ca.paa);
                };
                class GVAR(Action_Serbian) {
                    displayName = ECSTRING(common,camo_serbian);
                    condition = QUOTE(['Serbian'] call FUNC(canApplyScheme));
                    statement = QUOTE(['Serbian'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_serbian_ca.paa);
                };
                class GVAR(Action_USStripes) {
                    displayName = ECSTRING(common,camo_usstripes);
                    condition = QUOTE(['USStripes'] call FUNC(canApplyScheme));
                    statement = QUOTE(['USStripes'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_usstripes_ca.paa);
                };
                class GVAR(Action_USStains) {
                    displayName = ECSTRING(common,camo_usstains);
                    condition = QUOTE(['USStains'] call FUNC(canApplyScheme));
                    statement = QUOTE(['USStains'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_usstains_ca.paa);
                };
                class GVAR(Action_USFlash) {
                    displayName = ECSTRING(common,camo_usflash);
                    condition = QUOTE(['USFlash'] call FUNC(canApplyScheme));
                    statement = QUOTE(['USFlash'] call FUNC(applyCamoAction));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_usflash_ca.paa);
                };
                class GVAR(Action_Remove) {
                    displayName = CSTRING(removeCamoAction);
                    condition = QUOTE(call FUNC(hasCamoApplied));
                    statement = QUOTE(call FUNC(unsetCamo));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_camooff_ca.paa);
                };
            };
        };
    };
};
