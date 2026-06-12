#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Line-by-Line File Comparison Using File Descriptors
#
# This script demonstrates how to read from two files simultaneously, line by
# line, and compare their contents. It uses manually assigned file descriptors
# (FDs) as a robust way to manage multiple file streams.
#
# How it Works:
# 1. `exec 3< "file1"`: Opens `file1` for reading and assigns it to file
#    descriptor 3.
# 2. `exec 4< "file2"`: Opens `file2` for reading and assigns it to file
#    descriptor 4.
# 3. `read -r line <&3`: Reads one line from the stream associated with FD 3.
#    The `<&3` is crucial for specifying which stream to read from.
# 4. The `while` loop continues as long as at least one of the files still has
#    content to be read.
# 5. `exec 3<&-` / `exec 4<&-`: Explicitly closes the file descriptors. This
#    is good practice for resource management.
#
# This technique is useful for tasks that require lock-step processing of
# multiple files, like merging or diffing.
# ==============================================================================

# --- Error Handling ---
# A more informative error handler could be used.
# For example, using `caller` to get more context.
handle_error() {
    local exit_code=$?
    local line_num=$1
    echo "ERROR on line $line_num (exit code: $exit_code)" >&2
    exit 1
}
trap 'handle_error $LINENO' ERR

# --- Main Function ---
main() {
    local file_1
    local file_2

    # --- Argument Handling and Setup ---
    if [[ "$#" -eq 0 ]]; then
        echo "No arguments provided. Using temporary example files..."
        file_1=$(mktemp)
        file_2=$(mktemp)
        # Ensure temp files are removed on script exit.
        trap 'rm -f "$file_1" "$file_2"' EXIT

        # Populate the temporary files with sample content.
        cat >"$file_1" <<EOF
Line 1: Same
Line 2: Different
Line 3: Same
EOF
        cat >"$file_2" <<EOF
Line 1: Same
Line 2: Also Different
Line 3: Same
Line 4: Extra line in file 2
EOF
    elif [[ "$#" -eq 2 ]]; then
        file_1="$1"
        file_2="$2"
        if [[ ! -f "$file_1" ]] || [[ ! -f "$file_2" ]]; then
            echo "Error: One or both files do not exist." >&2
            exit 1
        fi
    else
        echo "Usage: ${0##*/} [file1 file2]" >&2
        exit 1
    fi

    echo "--- Comparing Files ---"
    echo "File 1: $file_1"
    echo "File 2: $file_2"
    echo "-----------------------"

    # 2. Open File Descriptors for reading.
    exec 3<"$file_1"
    exec 4<"$file_2"

    local line_num=0
    local eof1=0
    local eof2=0

    # 3. The main comparison loop.
    # A simpler loop structure could be:
    # while IFS= read -r line1 <&3 && IFS= read -r line2 <&4; do ...
    # However, this one correctly handles files of different lengths.
    while true; do
        ((line_num++))

        # Attempt to read from file 1. If it fails (EOF), set a flag.
        # `|| eof1=1` prevents `set -e` from exiting the script on EOF.
        IFS= read -r line1 <&3 || eof1=1
        # Attempt to read from file 2.
        IFS= read -r line2 <&4 || eof2=1

        # Exit the loop only when both files have reached their end.
        if ((eof1 && eof2)); then
            break
        fi

        # Compare the lines that were read.
        if [[ "$line1" != "$line2" ]]; then
            # Handle cases where one file is longer than the other.
            if ((eof1)); then
                echo "Line $line_num: File 1 ended, File 2 has: '$line2'"
            elif ((eof2)); then
                echo "Line $line_num: File 2 ended, File 1 has: '$line1'"
            else
                echo "Line $line_num DIFF: '$line1' vs '$line2'"
            fi
        fi
    done

    echo "-----------------------"
    echo "Comparison finished."

    # 4. Cleanup: Close the file descriptors.
    exec 3<&-
    exec 4<&-
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
