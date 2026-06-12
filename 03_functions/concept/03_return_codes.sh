#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_return_codes.sh — Return codes from functions
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── return from functions ────────────────────────────────────
# return exits a function with a code (0-255)
# 0 = success, non-0 = failure (same convention as exit codes)
is_even() {
    local num=$1
    if (( num % 2 == 0 )); then
        return 0   # Success: number is even
    else
        return 1   # Failure: number is odd
    fi
}

echo "=== Testing is_even ==="
is_even 4
echo "is_even 4 -> $?"   # 0 (success)

is_even 7 || true
echo "is_even 7 -> $?"   # 1 (failure)

# ── Using return codes with if ───────────────────────────────
# if directly checks the exit code of the function
echo ""
check_age() {
    local age=$1
    if (( age < 0 )) || (( age > 150 )); then
        return 1   # Invalid
    fi
    return 0   # Valid
}

if check_age 25; then
    echo "Age 25: valid"
fi
if ! check_age 200; then
    echo "Age 200: invalid"
fi

# ── true/false pattern ───────────────────────────────────────
# Use true and false as explicit return values in complex logic
has_access() {
    local user=$1
    local file=$2

    [[ "$user" == "root" ]] && return 0   # root has access to everything
    [[ -r "$file" ]] && return 0          # readable file
    return 1                              # no access
}

echo ""
has_access "alice" "/etc/shadow" || echo "alice cannot read /etc/shadow"

# ── Important: return vs exit ────────────────────────────────
# return  → exits the current FUNCTION
# exit    → exits the current SHELL/SCRIPT
demo_return_vs_exit() {
    return 42
    echo "This line never runs"  # Unreachable
}

demo_return_vs_exit || true
echo "Function returned: $?"   # 42