#!/usr/bin/env python3

import fnmatch
import os
import sys
import xml.etree.ElementTree as ET

# STRINGTABLE VALIDATOR
# Author: mharis001
# ---------------------
# Verifies all stringtable.xml files in the project. Checks for:
#   - proper XML tree structure.
#   - English as first translation.
#   - no Original translation.
#   - duplicated entries and languages.
#   - package names that match the addon folder and PACKAGE_NAME_STYLE.
#
# Keys are named STR_<PROJECT_NAME>_<Package name>_<name>. CBA's LSTRING/CSTRING macros build them from the
# `#define COMPONENT` of an addon, so the Package name has to be written like COMPONENT. Changing one
# without the other breaks the runtime lookup of the string.


######## GLOBALS #########
PROJECT_NAME = "CFR"

# "lower": Package names are lowercase (the addon folder name), "title": Package names are titlecase
PACKAGE_NAME_STYLE = "title"

# Languages every key is expected to be translated into, besides English. Missing translations are only
# reported (see report_coverage), they do not fail the validation, as untranslated keys fall back to English
TRANSLATIONS = [
    "German",
    "French",
    "Spanish",
    "Polish",
    "Russian",
    "Italian",
    "Czech",
    "Portuguese",
    "Chinese",
    "Chinesesimp",
    "Japanese",
    "Korean",
    "Ukrainian",
    "Turkish",
    "Hungarian",
    "Slovak",
    "Bulgarian",
    "Latin",
]
##########################


def check_stringtable(filepath):
    try:
        tree = ET.parse(filepath)
    except Exception as e:
        print("  ERROR: Failed to parse file. {}".format(e))
        return 1

    errors = 0

    # Verify that the root tag is Project and its name attribute is the project name
    root = tree.getroot()

    if root.tag != "Project":
        print("  ERROR: Invalid root tag '{}' found, must be 'Project'.".format(root.tag))
        errors += 1

    if root.get("name") != PROJECT_NAME:
        print("  ERROR: Invalid name attribute '{}' for Project tag, must be '{}'.".format(root.get("name"), PROJECT_NAME))
        errors += 1

    # Verify that the root has a Package tag and its name attribute matches the component's folder name
    package = root.find("Package")

    if package is None:
        print("  ERROR: Failed to find 'Package' tag under 'Project' tag.")
        errors += 1
    else:
        package_name = package.get("name")

        component_folder = os.path.basename(os.path.dirname(filepath))
        if package_name.lower() != component_folder:
            print("  ERROR: Package name attribute '{}' does not match the component folder name.".format(package_name))
            errors += 1

        if PACKAGE_NAME_STYLE == "lower" and package_name != package_name.lower():
            print("  ERROR: Package name attribute '{}' should be all lowercase.".format(package_name))
            errors += 1
        elif PACKAGE_NAME_STYLE == "title" and package_name.islower():
            print("  ERROR: Package name attribute '{}' is all lowercase, should be in titlecase.".format(package_name))
            errors += 1

        # Get all keys contained in the stringtable
        keys = package.findall("Key")

        for container in package.findall("Container"):
            keys.extend(container.findall("Key"))

        key_ids = []
        key_prefix = "STR_{}_{}_".format(PROJECT_NAME, package_name)

        for key in keys:
            key_id = key.get("ID")

            # Verify that the key has a valid ID attribute
            if key_id is None:
                print("  ERROR: Key '{}' had no ID attribute.".format(key_id))
                errors += 1
            elif key_id.find(key_prefix) != 0:
                print("  ERROR: Key '{}' does not have a valid ID attribute, should be in format {}{{name}}.".format(key_id, key_prefix))
                errors += 1

            key_ids.append(key_id)

            # Verify language entries for the key, check that the key:
            #   - contains at least one translation
            #   - does not contain an Original translation
            #   - has English as the first listed translation
            #   - has only one entry for each language
            entries = list(key)

            if len(entries) == 0:
                print("  ERROR: Key '{}' has no translation entries.".format(key_id))
                errors += 1
            else:
                if not key.find("Original") is None:
                    print("  ERROR: Key '{}' has an Original translation, unnecessary with English as first.".format(key_id))
                    errors += 1

                if entries[0].tag != "English":
                    print("  ERROR: Key '{}' does not have its English translation listed first.".format(key_id))
                    errors += 1

                languages = list(map(lambda l: l.tag, entries))

                for language in set(languages):
                    count = languages.count(language)

                    if count > 1:
                        print("  ERROR: Key '{}' has {} {} translations.".format(key_id, count, language))
                        errors += 1

        # Verify that key IDs are unique
        for id in set(key_ids):
            count = key_ids.count(id)

            if count > 1:
                print("  ERROR: Key '{}' is defined {} times.".format(id, count))
                errors += 1

    # Check whitespace for tabs and correct number of indenting spaces
    with open(filepath, "r", encoding = "utf-8") as file:
       spacing_depth = 0

       for line_number, line in enumerate(file, 1):
           if "\t" in line:
               print("  ERROR: Found a tab on line {}.".format(line_number))
               errors += 1

           line_clean = line.lstrip().lower()

           if line_clean.startswith("</key") or line_clean.startswith("</package") or line_clean.startswith("</project") or line_clean.startswith("</container"):
               spacing_depth -= 4

           line_spacing = len(line.lower()) - len(line_clean)

           if line_spacing != spacing_depth:
               print("  ERROR: Incorrect number of indenting spaces on line {}, currently {}, should be {}.".format(line_number, line_spacing, spacing_depth))
               errors += 1

           if line_clean.startswith("<key") or line_clean.startswith("<package") or line_clean.startswith("<project") or line_clean.startswith("<container"):
               spacing_depth += 4

    return errors


def report_coverage(filepaths, root_dir):
    # Count the keys translated into each language and list the keys that are not
    totals = {language: 0 for language in TRANSLATIONS}
    key_count = 0
    missing = []

    for filepath in filepaths:
        try:
            package = ET.parse(filepath).getroot().find("Package")
        except Exception:
            continue

        if package is None:
            continue

        for key in package.findall("Key"):
            key_count += 1
            languages = [entry.tag for entry in key]

            for language in TRANSLATIONS:
                if language in languages:
                    totals[language] += 1
                else:
                    missing.append((os.path.relpath(filepath, root_dir), key.get("ID"), language))

    print("Translation coverage ({} keys)".format(key_count))
    print("-----------------------")

    for language in TRANSLATIONS:
        print("  {:<8} {}/{}".format(language, totals[language], key_count))

    for filepath, key_id, language in missing:
        print("  WARNING: {} has no {} translation in {}.".format(key_id, language, filepath))

    print()


def main():
    print("Validating Stringtables")
    print("-----------------------")

    # Allow running from root directory and tools directory
    root_dir = ".."
    if os.path.exists("addons"):
        root_dir = "."

    # Check all stringtable.xml files in the project directory
    stringtable_files = []

    for root, _, files in os.walk(root_dir):
        for file in fnmatch.filter(files, "stringtable.xml"):
            if (".hemttout" in root): continue
            stringtable_files.append(os.path.join(root, file))

    stringtable_files.sort()

    bad_count = 0

    for filepath in stringtable_files:
        print("Checking {}:".format(os.path.relpath(filepath, root_dir)))

        errors = check_stringtable(filepath)

        if errors != 0:
            print("Found {} error(s).".format(errors))
            bad_count += 1

    print()

    report_coverage(stringtable_files, root_dir)

    if bad_count == 0:
        print("Stringtable Validation PASSED")
    else:
        print("Stringtable Validation FAILED")

    return bad_count


if __name__ == "__main__":
    sys.exit(main())
