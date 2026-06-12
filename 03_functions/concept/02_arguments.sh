#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_arguments.sh — Function arguments: $1, $2, $@, $#
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Positional parameters inside functions ───────────────────
# $1, $2, ... map to function arguments (NOT script arguments)
show_name() {
    echo "First name:  $1"
    echo "Last name:   $2"
}

echo "=== Positional parameters ==="
show_name "Alice" "Johnson"

# ── $@ — all arguments ───────────────────────────────────────
# "$@" expands to all args as separate quoted strings (safe)
show_all() {
    echo ""
    echo "Arguments ($# total):"
    local i=1
    for arg in "$@"; do
        echo "  Arg $i: $arg"
        (( i++ ))
    done
}

show_all "apple" "banana" "cherry" "date"

# ── $# — argument count ─────────────────────────────────────
require_arg() {
    if (( $# < 1 )); then
        echo "Error: missing required argument" >&2
        return 1
    fi
    echo "Required argument: $1"
}

echo ""
require_arg "hello"
require_arg || true  # Demonstrates the error case

# ── shift — consume arguments one by one ─────────────────────
# shift removes $1, shifts $2→$1, $3→$2, etc.
echo ""
consume_args() {
    echo "=== shift demo ==="
    while (( $# > 0 )); do
        echo "  Processing: $1"
        shift
    done
    echo "  No more arguments"
}

consume_args a b c d

# ── Default values with ${1:-default} ────────────────────────
# Provide a fallback if argument is not supplied
echo ""
greet_default() {
    local name="${1:-World}"
    echo "Hello, $name!"
}

greet_default
greet_default "Alice"