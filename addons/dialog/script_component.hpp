#define COMPONENT dialog
#define COMPONENT_BEAUTIFIED Dialog
#include "\z\cfr\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define ENABLE_PERFORMANCE_COUNTERS

#include "\z\cfr\addons\main\script_macros.hpp"

///////////////////////////////////////////////////////////////////////////
/// Dialog & control IDs
///////////////////////////////////////////////////////////////////////////

#define IDD_DIALOG           311

#define IDC_PICTURE_BOX      4961
#define IDC_PICTURE_NOTEPAD  4966
#define IDC_TEXT_HELMET      4862
#define IDC_PICTURE_HELMET   4963
#define IDC_TEXT_GOGGLES     4863
#define IDC_PICTURE_GOGGLES  4964
#define IDC_TEXT_NV          4864
#define IDC_PICTURE_NV       4965
#define IDC_RTT_MIRROR       4967

#define IDC_LISTBOX_COUNTRY  5262
#define IDC_LISTBOX_CAMOFACE 5263
#define IDC_BUTTON_LAYER1    5362
#define IDC_BUTTON_LAYER2    5363
#define IDC_BUTTON_LAYER3    5364
#define IDC_BUTTON_UNCAMO    5365

///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_CHECKBOX         77

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// how far away (metres) the painter may be from the unit whose face they are painting or cleaning,
// checked again every frame of the progress bar so walking away cancels it. Slightly more than the
// 1.5 m ACE_Head's interaction point reaches (the entries are on it, see CfgVehicles.hpp), since this
// measures between the two units rather than to the head and so has to allow for a lying or kneeling target
#define BUDDY_MAX_DISTANCE 2.5

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4
