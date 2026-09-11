// Extends ZEN's own context menu action tree (a foreign mod's config class, hence the literal
// "zen_context_menu_actions" name below rather than an EGVAR() - EGVAR only reaches components of
// this mod). See https://github.com/zen-mod/ZEN/blob/master/addons/context_actions/CfgContext.hpp for
// ZEN's own equivalent classes and the condition/statement/insertChildren scripting convention this
// follows.
class zen_context_menu_actions {
    class CFR_Camouflage {
        displayName = CSTRING(menuName);
        icon = ICON_CAMOUFLAGE;
        condition = QUOTE(GVAR(enableContextActions) && {(_objects findIf {_x isKindOf 'CAManBase'} != -1) || {_groups findIf {units _x findIf {_x isKindOf 'CAManBase'} != -1} != -1}});
        insertChildren = QUOTE([ARR_2(_objects,_groups)] call FUNC(getCamoActions));
        priority = 50;
    };
};
