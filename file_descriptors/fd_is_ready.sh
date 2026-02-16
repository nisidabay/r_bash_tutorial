#!/usr/bin/env bash

# Enhanced file descriptor readiness checker
# This script demonstrates how to use file descriptors to check if a process is ready to produce data
# with configurable timeout and improved error handling

set -euo pipefail

# Configuration parameters
# Timeout in seconds before giving up on waiting for data
readonly TIMEOUT=1

# Error handling function
handle_error() {
    local error_code=$?
    local line=$1
    echo "ERROR on line $line (exit code: $error_code)" >&2
    exit 1
}

# Trap error handling
trap 'handle_error $LINENO' ERR

# Main execution function
main() {
    # Set up file descriptor 3 to read from a temporary pipe
    # This simulates a process that takes time to produce data
    exec 3< <(
        sleep $((RANDOM % 3 + 2)) # Random delay between 2-4 seconds
        echo "Hello from process"
    )

    local line=""
    local timeout_counter=0

    # Wait for data to become available with configurable timeout
    while [[ -z "$line" ]]; do
        echo "No data ready yet! (Attempt $((timeout_counter + 1)) of $((TIMEOUT * 10)))" >&2

        # Check if data is ready with configurable timeout
        if read -r -t $TIMEOUT line <&3; then
            break
        fi

        # Increment counter and check if we've exceeded the maximum attempts
        timeout_counter=$((timeout_counter + 1))

        # Safety check to prevent infinite loops
        if [[ $timeout_counter -gt 100 ]]; then
            echo "Error: Timeout exceeded after 100 attempts" >&2
            exit 1
        fi
    done

    # Process the received data
    if [[ -n "$line" ]]; then
        echo "Data received successfully: $line"
    else
        echo "Error: Failed to receive data from process" >&2
        exit 1
    fi

    # Close the file descriptor
    exec 3<&- # Close file descriptor 3
}

# Execute the main function
main
