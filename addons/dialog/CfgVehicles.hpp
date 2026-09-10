class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions  {
            class GVAR(SelfAction) {
                displayName = CSTRING(Action);
                condition = QUOTE([ACE_player] call FUNC(canShowAction));
                statement = QUOTE(call FUNC(startDialog));
                showDisabled = 0;
                priority = 4;
                icon = QPATHTOEF(common,data\UI\Icon_camoon_ca.paa);
            };
        };
    };
};
