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

                // one child per registered camo scheme (CfgCamoSchemes, in cfr_common), built each time
                // the menu opens so schemes added by other addons appear without being listed here
                insertChildren = QUOTE(call FUNC(getSchemeActions));

                class GVAR(Action_Remove) {
                    displayName = CSTRING(removeCamoAction);
                    condition = QUOTE([] call FUNC(hasCamoApplied));
                    statement = QUOTE([] call FUNC(unsetCamo));
                    showDisabled = 0;
                    icon = QPATHTOEF(common,data\UI\Icon_camooff_ca.paa);
                };
            };
        };
    };
};
