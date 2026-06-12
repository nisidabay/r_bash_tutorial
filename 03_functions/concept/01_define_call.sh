#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_define_call.sh — Defining and calling functions
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Function definition syntax ───────────────────────────────
# Two valid syntaxes — this one (with () ) is the most common
greet() {
    echo "Hello from inside a function!"
}

# Also valid (less common): function name() { ... }
function warn() {
    echo "Warning: something needs attention!"
}

# ── Calling functions ────────────────────────────────────────
# Call a function like any other command — no parentheses needed
greet
warn

# ── Functions must be defined before use ─────────────────────
# Bash reads scripts top-to-bottom. This would fail:
#   call_me  # ERROR: call_me not defined yet!
call_me() {
    echo "Now I'm defined — you can call me!"
}
call_me  # This works: defined above the call

# ── Functions can call other functions ───────────────────────
echo ""
inner() {
    echo "  Inner function called"
}

outer() {
    echo "Outer function called"
    inner
}

outer

# ── The main() pattern (simple version) ──────────────────────
# Organize scripts with a main function as entry point
print_banner() {
    echo "=== Bash Functions Demo ==="
}

main() {
    print_banner
    greet
    warn
    echo "Done!"
}

# Call main only if script is executed (not sourced)
main "$@"