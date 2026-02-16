#!/usr/bin/env bash
#
# This script demonstrates reading from a file descriptor. It accepts input
# from command-line arguments or piped stdin, processes it through a temporary
# file, and uses proper error handling and cleanup.

set -euo pipefail

declare -g input_file
declare -g DEBUG=false

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
    -d | --debug)
        DEBUG=true
        shift
        ;;
    -*)
        echo "Unknown option: $1" >&2
        exit 1
        ;;
    *)
        break
        ;;
    esac
done

# Enable debug mode if requested
if ${DEBUG}; then
    set -x
fi

# Traps errors and exits with a custom message.
# Globals:
#   None
# Arguments:
#   $1: The line number where the error occurred.
#   $2: A custom error message (optional).
#   $?: The exit code of the last command.
# Outputs:
#   Writes an error message to STDERR.
handle_error() {
    local error_code=$?
    local line=${1}
    local message=${2:-"An unexpected error occurred."}
    echo "ERROR on line ${line}: ${message} (exit code: ${error_code})" >&2
    exit "${error_code}"
}

trap 'handle_error $LINENO' ERR

# Main function to handle script logic.
# Globals:
#   input_file: Used to store the path to the temporary input file.
# Arguments:
#   $@: Input arguments for the script.
# Outputs:
#   Writes processed lines to STDOUT.
#   Writes input arguments or stdin content to a temporary file.
main() {
    input_file=$(mktemp)

    # Ensure the temporary file is removed on script exit.
    trap 'rm -f "${input_file}"' EXIT SIGTERM SIGINT

    # If stdin is a terminal and arguments are provided, use arguments as input.
    # Otherwise, read from stdin (pipe or interactive).
    if [[ -t 0 && -n "$*" ]]; then
        echo "$(printf "%s\n" "$@")" >"${input_file}"
    else
        cat >"${input_file}"
    fi

    # Open the temporary file for reading on file descriptor 3.
    exec 3<"${input_file}"

    # Read from file descriptor 3 line by line.
    while IFS= read -r -u 3 line; do
        echo "${line}"
    done

    # Close the file descriptor.
    exec 3<&-

    # The EXIT trap will clean up the temporary file.
}

# Execute main function if the script is run directly.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
