#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Null-Safe File Listing with `find` and `read`
#
# This script demonstrates the most robust method for handling filenames that
# may contain spaces, newlines, or other special characters.
#
# The key techniques are:
# - `find "$dir" -type f -print0`: This command finds all files (`-type f`) in
#   the specified directory and prints their paths separated by a null
#   character (`\0`) instead of a newline. Since the null character is the one
#   character that cannot exist in a valid Unix filename, it is the perfect
#   delimiter.
#
# - `while IFS= read -r -d '' file; do ... done`: This loop reads the
#   null-delimited output from `find`.
#     - `IFS=`: Prevents leading/trailing whitespace from being trimmed.
#     - `read -r`: Prevents backslash escapes from being interpreted.
#     - `read -d ''`: Sets the delimiter for `read` to the null character.
#
# - `< <(...)`: This is process substitution. It allows the output of the `find`
#   command to be treated like a file, which is then redirected as standard
#   input to the `while` loop. This is generally preferred over a traditional
#   pipe (`|`) because it prevents the `while` loop from running in a subshell,
#   allowing variables (like the `files` array) to remain in the main script's scope.
# ==============================================================================

# --- Functions ---

# Reads file paths from a directory in a null-safe manner and prints them.
read_files_null_safe() {
    local dir="$1"
    local -a files=() # Create an empty array to store file paths.

    # Use `mapfile` (or `readarray`) for a more concise way to populate the array.
    # It's generally more efficient than a `while` loop for this purpose.
    mapfile -t -d '' files < <(find "$dir" -type f -print0)

    # The while loop version is also perfectly valid and sometimes more readable:
    #
    # while IFS= read -r -d '' file; do
    #     files+=("$file")
    # done < <(find "$dir" -type f -print0)

    echo "Found ${#files[@]} files in '$dir':"
    # `printf` is used here for safe and accurate printing of each array element.
    printf -- ' - %s\n' "${files[@]}"
}

# --- Main Entry Point ---

main() {
    # Default to the current directory if no argument is provided.
    local dir="${1:-.}"

    # Validate that the target directory exists.
    if [[ ! -d "$dir" ]]; then
        echo "Error: Directory '$dir' not found." >&2
        exit 1
    fi

    read_files_null_safe "$dir"
}

# Ensure `main` runs only when the script is executed directly.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
