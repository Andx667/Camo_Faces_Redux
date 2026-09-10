# Main (`cfr_main`)

The main addon for Camo Faces Redux.

It carries the mod's shared preprocessor macros (`script_mod.hpp`, `script_macros.hpp`), version information (`script_version.hpp`), and registers the mod's editor sub-category. Every other `cfr_*` component includes this addon's headers before defining its own `script_component.hpp`.
