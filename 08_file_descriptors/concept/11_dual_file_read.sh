#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Comparing Two Files in Bash
#
# This script demonstrates two different methods for comparing the contents of
# two files:
#
# 1.  **Side-by-side Reading**: The `read_two_files_side_by_side` function reads
#     from both files simultaneously using multiple file descriptors and prints
#     their corresponding lines next to each other.
#
# 2.  **Using `diff`**: The `diff_files_with_diff` function uses the standard
#     `diff` command to generate a detailed, colored report of the differences.
#
# Usage:
#   ./reading_two_files.sh <file1> <file2>
# ==============================================================================

# --- Functions ---

# Reads from two files simultaneously and prints their lines side-by-side.
# Note: This loop will stop as soon as the shorter of the two files ends.
# It's useful for a quick visual comparison of files expected to have the same
# number of lines.
read_two_files_side_by_side() {
    local file1="$1"
    local file2="$2"

    echo "--- Side-by-Side Comparison ---"
    # The `while` loop condition reads from both file descriptors.
    # It continues as long as *both* reads are successful.
    while IFS= read -r line1 && IFS= read -r line2 <&3; do
        printf "File 1: %-40s | File 2: %s\n" "$line1" "$line2"
    done <"$file1" 3<"$file2" # FD 0 (stdin) is redirected from file1, FD 3 from file2.

    # It's good practice to explicitly close the extra file descriptor.
    exec 3<&-
    echo "-------------------------------"
}

# Uses the `diff` command to compare two files.
diff_files_with_diff() {
    local file1="$1"
    local file2="$2"

    echo -e "\n--- 'diff' Command Comparison ---"
    # `diff -u` provides a "unified" diff format, which is standard.
    # `--color=always` forces colored output even when piped.
    # The `|| true` is a crucial addition when `set -e` is active. `diff` exits
    # with code 1 if differences are found, which would normally terminate the
    # script. `|| true` ensures the script continues regardless of diff's exit code.
    diff -u --color=always "$file1" "$file2" || true
    echo "-------------------------------"
}

# --- Main Logic ---
main() {
    # Check for the correct number of arguments.
    if (($# != 2)); then
        echo "Usage: ${0##*/} <file1> <file2>" >&2
        exit 1
    fi

    # Check if files exist.
    if [[ ! -f "$1" ]] || [[ ! -f "$2" ]]; then
        echo "Error: One or both files not found." >&2
        exit 1
    fi

    # Run both comparison functions.
    read_two_files_side_by_side "$1" "$2"
    diff_files_with_diff "$1" "$2"
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
