// Bohemia's own Marksmen DLC camo faces (CamoHead_* and the arid/lush/semi-arid heads) are not CFR
// classes, so unlike CfgCamoRegistry.hpp this is written by hand. Each entry is "<plain face> =
// <BI's camo face>". The schemes themselves (and their Marksmen DLC gate) are defined in cfr_common's
// CfgCamo.hpp; see there for why these are four separate schemes rather than one.
//
// Included from inside CfgCamoSchemes by the generated CfgCamoRegistry.hpp.

// one BI-authored camo face per base face, named CamoHead_<Race>_<NN>_F rather than by any
// suffix pattern, hence an explicit table
class Vanilla {
    class Faces {
        PersianHead_A3_01 = "CamoHead_Persian_01_F";
        PersianHead_A3_02 = "CamoHead_Persian_02_F";
        PersianHead_A3_03 = "CamoHead_Persian_03_F";
        AsianHead_A3_01 = "CamoHead_Asian_01_F";
        AsianHead_A3_02 = "CamoHead_Asian_02_F";
        AsianHead_A3_03 = "CamoHead_Asian_03_F";
        AfricanHead_01 = "CamoHead_African_01_F";
        AfricanHead_02 = "CamoHead_African_02_F";
        AfricanHead_03 = "CamoHead_African_03_F";
        GreekHead_A3_01 = "CamoHead_Greek_01_F";
        GreekHead_A3_02 = "CamoHead_Greek_02_F";
        GreekHead_A3_03 = "CamoHead_Greek_03_F";
        GreekHead_A3_04 = "CamoHead_Greek_04_F";
        GreekHead_A3_05 = "CamoHead_Greek_05_F";
        GreekHead_A3_06 = "CamoHead_Greek_06_F";
        GreekHead_A3_07 = "CamoHead_Greek_07_F";
        GreekHead_A3_08 = "CamoHead_Greek_08_F";
        GreekHead_A3_09 = "CamoHead_Greek_09_F";
        WhiteHead_01 = "CamoHead_White_01_F";
        WhiteHead_02 = "CamoHead_White_02_F";
        WhiteHead_03 = "CamoHead_White_03_F";
        WhiteHead_04 = "CamoHead_White_04_F";
        WhiteHead_05 = "CamoHead_White_05_F";
        WhiteHead_06 = "CamoHead_White_06_F";
        WhiteHead_07 = "CamoHead_White_07_F";
        WhiteHead_08 = "CamoHead_White_08_F";
        WhiteHead_09 = "CamoHead_White_09_F";
        WhiteHead_10 = "CamoHead_White_10_F";
        WhiteHead_11 = "CamoHead_White_11_F";
        WhiteHead_12 = "CamoHead_White_12_F";
        WhiteHead_13 = "CamoHead_White_13_F";
        WhiteHead_14 = "CamoHead_White_14_F";
        WhiteHead_15 = "CamoHead_White_15_F";
        WhiteHead_16 = "CamoHead_White_16_F";
        WhiteHead_17 = "CamoHead_White_17_F";
        WhiteHead_18 = "CamoHead_White_18_F";
        WhiteHead_19 = "CamoHead_White_19_F";
        WhiteHead_20 = "CamoHead_White_20_F";
        WhiteHead_21 = "CamoHead_White_21_F";
    };
};

// Marksmen also ships three environment-specific heads, but only as variants of three base faces.
// Which base face each is painted over was confirmed by comparing the textures outside the painted area.
class VanillaArid {
    class Faces {
        PersianHead_A3_01 = "PersianHead_A3_04_a";
        GreekHead_A3_02 = "GreekHead_A3_10_a";
        WhiteHead_11 = "WhiteHead_22_a";
    };
};
class VanillaLush {
    class Faces {
        PersianHead_A3_01 = "PersianHead_A3_04_l";
        GreekHead_A3_02 = "GreekHead_A3_10_l";
        WhiteHead_11 = "WhiteHead_22_l";
    };
};
class VanillaSemiArid {
    class Faces {
        PersianHead_A3_01 = "PersianHead_A3_04_sa";
        GreekHead_A3_02 = "GreekHead_A3_10_sa";
        WhiteHead_11 = "WhiteHead_22_sa";
    };
};
