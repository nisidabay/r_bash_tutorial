#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Reading from a File Descriptor with a Timeout
#
# This script demonstrates how to read from a stream line by line, but with a
# timeout on the `read` command. This is useful for handling streams that may
# pause or stop providing data.
#
# How it Works:
# 1. A file (`log_file.txt`) is created for the demo.
# 2. `exec 3< <(...)`: A process substitution creates a background process. In
#    this case, it waits for 2 seconds and then `cat`s the contents of the
#    log file. The output of this entire process is connected to file descriptor 3.
# 3. `while read -r -t 3 line <&3`: This is the core of the script.
#    - The `while` loop continues as long as `read` successfully reads a line.
#    - `-t 3`: `read` will wait a maximum of 3 seconds for a line to arrive. If
#      no line is read in that time, `read` will exit with a non-zero status
#      code, causing the `while` loop to terminate.
#    - If `set -e` is active, the script would exit when `read` times out. The
#      `while` loop condition naturally handles this non-zero exit code,
#      gracefully ending the loop without terminating the script.
# ==============================================================================

# --- Global Configuration ---
declare -g FILE="log_file.txt"

# --- Error Handling ---
handle_error() {
    local exit_code=$?
    local line_num=$1
    echo "Error on line $line_num (exit code: $exit_code)" >&2
    # Ensure the file descriptor is closed on error.
    exec 3<&- 2>/dev/null
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Main Logic ---
main() {
    # Create a dummy log file for the demonstration.
    cat >"$FILE" <<EOF
First line of the log.
Second line of the log.
Third line, and so on.
EOF

    # Ensure the dummy file is cleaned up when the script exits.
    trap 'rm -f "$FILE"' EXIT

    echo "Preparing to read from '$FILE' with a simulated delay..."

    # Use process substitution to feed the file content into file descriptor 3
    # after a delay. This simulates a slow-starting process.
    exec 3< <(
        sleep 2
        cat "$FILE"
    )

    echo "Reading from stream with a 3-second timeout per line..."
    # The `while` loop will continue as long as `read` successfully finds a line.
    # It will terminate gracefully if `read` times out.
    while read -r -t 3 line <&3; do
        echo "  Got line: $line"
    done

    echo "Finished reading (or the read operation timed out)."

    # Cleanly close the file descriptor.
    exec 3<&-
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
