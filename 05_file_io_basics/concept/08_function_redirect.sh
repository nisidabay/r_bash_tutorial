#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Function Output Redirection for Logging
#
# This script demonstrates a powerful feature of shell scripting: redirecting
# the entire output (both stdout and stderr) of a function to a file. This is
# an elegant way to create wrapper functions for logging or other purposes.
#
# How it works:
# The `>> logfile.txt 2>&1` at the end of the `log_operation` function's
# definition applies to *every* command executed inside that function.
#
# - `>> logfile.txt`: Appends standard output (stdout) to `logfile.txt`.
# - `2>&1`: Redirects standard error (stderr, file descriptor 2) to the same
#   place as standard output (file descriptor 1). The result is that both
#   normal output and error messages are appended to the log file.
# ==============================================================================

# --- Configuration ---
readonly LOG_FILE="logfile.txt"

# --- Functions ---

# A wrapper function that logs all output of the command passed to it.
# Note: A more robust version would pass arguments properly, e.g., `log_operation cmd arg1 arg2`
# and execute them with `"$@"`.
log_operation() {
    local cmd="$1"
    echo "--- Running: '$cmd' at $(date) ---"
    # Execute the command. Its stdout and stderr will be redirected.
    $cmd
    echo "--- Finished: '$cmd' ---"
    echo "" # Add a blank line for readability
} >> "$LOG_FILE" 2>&1

# A sample function to be logged.
operation1() {
    echo "Starting operation 1."
    echo "This is a standard output message from operation1."
    # This will go to stderr, but will be captured by the redirection.
    echo "This is an error message from operation1." >&2
}

# Another sample function.
operation2() {
    echo "Starting operation 2."
    ls -l /path/that/does/not/exist # This command will fail
}

# --- Main Logic ---

# Clear the log file at the start of the script for a clean run.
# The `>` operator truncates the file if it exists or creates it if it doesn't.
> "$LOG_FILE"

echo "Running operations and logging output to '$LOG_FILE'."

# These function calls will have all their internal output captured in the log file.
# The user will not see the output of `operation1` or `operation2` on the console.
log_operation operation1
log_operation operation2

echo "All operations complete. Check '$LOG_FILE' for details."

# Display the contents of the log file for verification.
echo "--- Contents of $LOG_FILE ---"
cat "$LOG_FILE"
echo "---------------------------"
