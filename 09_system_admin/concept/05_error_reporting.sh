#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Temporary File and Error Handling Demo
#
# This script demonstrates:
# 1. Creating a temporary file using `mktemp`.
# 2. Using a `trap` to ensure a `cleanup` function is called on script exit.
# 3. A robust cleanup function that removes the temporary file.
# 4. A basic error-reporting mechanism that shows where a failure occurred.
# ==============================================================================

# --- Global Variables ---
TMPFILE=""

# --- Functions ---

# Cleanup function executed on script exit
cleanup() {
    local exit_code=$? # Capture the exit code of the last command

    # Safely remove the temporary file if it exists
    if [[ -n "${TMPFILE:-}" ]] && [[ -f "$TMPFILE" ]]; then
        rm -f "$TMPFILE"
        echo "Temporary file '$TMPFILE' removed."
    fi

    # If the script exited with an error, print a diagnostic message
    if ((exit_code != 0)); then
        # FUNCNAME[1] is the caller of cleanup(), BASH_LINENO[0] is its line number
        local failed_func="${FUNCNAME[1]}"
        local failed_line="${BASH_LINENO[0]}"
        echo "Script failed in function '${failed_func}' at line ${failed_line} with exit code ${exit_code}." >&2
    fi

    exit "$exit_code"
}

# Set the trap to call the 'cleanup' function on any script exit signal
trap cleanup EXIT

# Main function of the script
main() {
    # Create a temporary file and store its path in the global variable
    TMPFILE=$(mktemp)
    echo "Temporary file created: $TMPFILE"

    # --- Script logic goes here ---
    echo "Doing some work..."

    # To test the error handler, uncomment the following line:
    # command_that_does_not_exist

    # Simulate a deliberate error to trigger the trap
    echo "Simulating an error..."
    false
    echo "This line will not be executed."
}

# --- Script Entry Point ---
main
