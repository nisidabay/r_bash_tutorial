#!/usr/bin/env bash

set -euo pipefail

declare -g FILE="log_file.txt"

handle_error() {
    echo "Error on line $1: $2" >&2
    exit 1
}

trap 'handle_error $LINENO' ERR

command -v sleep &>/dev/null || { handle_error $LINENO "sleep command not found."; }
command -v cat &>/dev/null || { handle_error $LINENO "cat command not found."; }

main() {
    if [[ ! -f "$FILE" ]]; then
        handle_error $LINENO "File does not exist"
    fi

    exec 3< <(
        sleep 2
        cat "$FILE"
    ) # Simulate slow input

    while read -r -t 3 line <&3; do
        echo "Got: $line"
    done

    echo "Done reading (or timed out)"
    exec 3<&-
}

main "$@"
