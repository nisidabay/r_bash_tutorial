#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Safe File Listing with `nullglob`
#
# This script demonstrates a safe way to handle file listings within Bash
# itself, avoiding the pitfalls of parsing the output of `ls`.
#
# Key Techniques:
# - `shopt -s nullglob`: This is a crucial shell option. When enabled, if a
#   globbing pattern (like `*` or `*.txt`) matches no files, it expands to an
#   empty string instead of the pattern itself. This allows you to reliably
#   check if a directory is empty.
#
# - `local files=("$dir"/*)`: The glob `"$dir"/*` is expanded into an array. Each
#   matching file or directory becomes a separate element in the `files` array.
#   This is the correct way to capture a list of files for iteration.
#
# - `shopt -u nullglob`: It's good practice to unset the shell option after use
#   to avoid unintended side effects in other parts of the script.
#
# - `printf -- ' - %s\n' "${files[@]}"`: This is the safest way to print the
#   contents of the array. `printf` handles any special characters in the
#   filenames correctly, printing each element on a new line. Using `%s` is
#   generally better for direct display than `%q`, which is meant for shell-escaped
#   output.
# ==============================================================================

# --- Functions ---

# Lists files in a given directory safely using a glob pattern.
list_files_safely() {
    local dir="$1"

    # Check if the provided path is actually a directory.
    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' is not a valid directory." >&2
        return 1
    fi

    # Enable nullglob to handle empty directories correctly.
    shopt -s nullglob
    # Expand the glob into an array.
    local files=("$dir"/*)
    # Disable nullglob immediately after use.
    shopt -u nullglob

    # Check if the array is empty.
    if ((${#files[@]} == 0)); then
        echo "The directory '$dir' is empty."
        return 0
    fi

    echo "Found ${#files[@]} items in '$dir':"
    # Print each item from the array on a new line.
    printf -- ' - %s\n' "${files[@]}"
}

# --- Main Entry Point ---

main() {
    # Use the first argument as the target directory, or default to the current directory.
    local target_dir="${1:-.}"
    list_files_safely "$target_dir"
}

# Ensure `main` runs only when the script is executed directly.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
