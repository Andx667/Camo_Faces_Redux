# Contributing

## Setting up the development environment

1. Clone the repository from GitHub.
2. Install [HEMTT](https://hemtt.dev/):

    ```cmd
    winget install hemtt
    ```

3. Build the mod with `hemtt build`, or validate it without building via `hemtt check`.

Feel free to add yourself to the list of [Authors](https://github.com/Andx667/CamoFacesRedux/blob/main/authors.txt) in your PR.

## Coding guidelines

This mod follows the same [coding guidelines as the ACE3 mod](https://ace3.acemod.org/wiki/development/coding-guidelines) — naming conventions, function headers, bracket/spacing style, and the general avoidance of scheduled space (`spawn`/`execVM`) and magic numbers.

The project's `.hemtt/lints.toml` also bans `spawn`, `execVM`, and `remoteExec` outright — use CBA's function/event system (`CBA_fnc_addEventHandler` / `CBA_fnc_globalEvent`) for networking instead.

## Validating changes

Before opening a PR, run:

```cmd
hemtt check
python tools/stringtable_validator.py
python tools/config_style_checker.py
```

These mirror the checks run in CI (`.github/workflows/hemtt.yml` and `arma.yml`).
