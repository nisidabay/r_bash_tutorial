#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_main_pattern.sh — The main() entry point pattern
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Why main() matters ───────────────────────────────────────
# Without main(), code at the top level runs when the script is
# sourced (imported), not just when executed. The main() pattern
# keeps the top level clean and prevents side effects on source.

# Helper functions defined at the top (available when sourced)
usage() {
    echo "Usage: $0 [name]"
    echo "Demonstrates the main() entry point pattern"
}

greet() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

# shellcheck disable=SC2120  # intentional: print_env called without args for demo
print_env() {
    echo "Script:    $0"
    echo "BASH_SOURCE: ${BASH_SOURCE[0]}"
    echo "Arguments: $#"
}

# ── The BASH_SOURCE guard ────────────────────────────────────
# [[ "${BASH_SOURCE[0]}" == "$0" ]] checks if the script is being
# EXECUTED (bash script.sh) or SOURCED (source script.sh).
#
# - $0: the name of the currently executing script/shell
# - ${BASH_SOURCE[0]}: the file where this code sits
#
# When executed directly:  BASH_SOURCE[0] == $0
# When sourced:            BASH_SOURCE[0] != $0  (it's the caller's file)

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    # Script is being EXECUTED — run main
    main() {
        echo "=== main() pattern demo ==="
        # shellcheck disable=SC2119  # intentional: no args, uses default behavior
        print_env
        echo ""
        greet "${1:-}"
    }
    main "$@"
else
    # Script is being SOURCED — just export helpers
    # No auto-execution! Source consumers can call greet() directly.
    :
fi