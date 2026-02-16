#!/usr/bin/env BASH

set -euo pipefail

TMPFILE=""

cleanup() {
    local exit_code=$?
    if [[ -n "${TMPFILE:-}" ]] && [[ -f "$TMPFILE" ]]; then
        rm -f "$TMPFILE"
    fi
    if ((exit_code != 0)); then
        echo "Script failed on function: ${FUNCNAME[0]}, line: ${BASH_LINENO[0]:-unknown}." >&2
    fi
    exit $exit_code
}

trap cleanup EXIT

main() {
    TMPFILE=$(mktemp)
    echo "Temporary file created: $TMPFILE"
    # Simulate an error
    false
}

main "$@"
