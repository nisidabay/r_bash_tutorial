#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Non-Blocking Read with Timeout from a File Descriptor
#
# This script demonstrates how to read from a file descriptor in a non-blocking
# way using a timeout. This is a crucial technique for interacting with
# background processes or other streams that may not produce data immediately.
#
# How it Works:
# 1. `exec 3< <(...)`: A process substitution is used to create a background
#    process (in this case, `sleep` followed by `echo`). The standard output
#    of this process is connected to file descriptor 3.
# 2. `read -r -t $TIMEOUT line <&3`: This is the key command.
#    - `read -r`: Reads a line of input raw (disabling backslash interpretation).
#    - `-t $TIMEOUT`: Sets a timeout. `read` will wait for a maximum of
#      `$TIMEOUT` seconds for a complete line to be available.
#    - `<&3`: Specifies that `read` should get its input from file descriptor 3.
# 3. `read`'s Exit Code:
#    - If `read` successfully reads a line within the timeout, it returns 0.
#    - If `read` times out before a line is available, it returns a non-zero
#      exit code (greater than 128). `set -e` would normally cause the script
#      to exit here, so we must handle this case.
#
# This script uses a `while` loop to show how one might poll for data, but a
# single `read -t` is often sufficient.
# ==============================================================================

# --- Configuration ---
# Timeout in seconds before `read` gives up.
readonly READ_TIMEOUT=5

# --- Error Handling ---
handle_error() {
    local exit_code=$?
    local line_num=$1
    echo "ERROR on line $line_num (exit code: $exit_code)" >&2
    # It's good practice to also close any open FDs here if needed.
    exec 3<&-
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# --- Main Logic ---
main() {
    echo "Setting up a background process that will produce data in a few seconds..."
    # Set up file descriptor 3 to read from a process that simulates a delay.
    exec 3< <(
        sleep 3
        echo "Hello from the background process"
    )

    echo "Waiting for data with a ${READ_TIMEOUT}-second timeout..."

    local line
    # Attempt to read from the file descriptor.
    # The `if` statement checks the exit code of `read`.
    if read -r -t "$READ_TIMEOUT" line <&3; then
        # This block executes if `read` was successful (exit code 0).
        echo "✅ Data received successfully: '$line'"
    else
        # This block executes if `read` timed out (non-zero exit code).
        echo "❌ Timed out after $READ_TIMEOUT seconds. No data was received." >&2
        # Close the FD and exit with an error code.
        exec 3<&-
        exit 1
    fi

    # It's good practice to close file descriptors when you're done with them.
    exec 3<&-
    echo "File descriptor 3 has been closed."
}

# --- Script Entry Point ---
main
