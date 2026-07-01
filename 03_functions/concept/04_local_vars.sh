#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_local_vars.sh — local variables and variable scope
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Variables are global by default ──────────────────────────
# Without local, variables leak outside the function
demo_leak() {
    leaked="I escape the function!"
}
demo_leak
echo "After demo_leak: leaked='$leaked'"  # Still accessible!

# ── local prevents leaking ───────────────────────────────────
# local creates a variable scoped to the function only
demo_safe() {
    local safe="I stay inside the function"
    echo "  Inside function: safe='$safe'"
}
echo ""
demo_safe
# echo "$safe"  # This would be empty — safe is unset outside

# ── local in practice: avoid collisions ──────────────────────
# Two functions can use the same variable name safely with local
item="global item"

process_order() {
    local item="$1"
    echo "  Processing order: $item"
}

echo ""
echo "Before process_order: item='$item'"
process_order "widget"
echo "After process_order:  item='$item'"   # Still "global item"

# ── local with initialization ─────────────────────────────────
# Always initialize local variables to avoid inheriting values
greet_user() {
    local name="${1:-unknown}"
    local greeting="Hello"

    echo "$greeting, $name!"
}

echo ""
greet_user "Alice"
greet_user

# ── local -n (nameref) preview ───────────────────────────────
# local -n creates a reference to another variable (like a pointer)
# Bash 4.3+ feature
update_var() {
    local -n ref=$1
    # shellcheck disable=SC2034  # ref is used via nameref, not read directly
    ref="new value"
}

echo ""
myvar="old value"
echo "Before nameref: myvar='$myvar'"
update_var myvar
echo "After nameref:  myvar='$myvar'"