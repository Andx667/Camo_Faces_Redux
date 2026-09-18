class CfgFaces {

    class Default;
    class Man_A3: Default {

        #include "Faces_Persian.hpp"
        #include "Faces_African.hpp"
        #include "Faces_Asian.hpp"
        #include "Faces_White.hpp"
        #include "Faces_Greek.hpp"
        // Heads added by later DLCs. The classes are defined unconditionally, exactly as the
        // Vanilla scheme already references BI's Marksmen CamoHead_* faces - config is static,
        // so ownership is enforced at runtime by the isDLCAvailable gate in fnc_init.sqf.
        #include "Faces_Tanoan.hpp"
        #include "Faces_Livonian.hpp"
        #include "Faces_Russian.hpp"
    };
};
