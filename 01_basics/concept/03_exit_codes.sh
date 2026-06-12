#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_exit_codes.sh — Exit codes and the $? variable
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── The $? variable ──────────────────────────────────────────
# Every command returns an exit code: 0 = success, non-0 = failure
echo "Exit code of 'echo' (success): $?"   # Should be 0

# Run a command that fails (capture exit code before || true)
set +e   # temporarily disable exit-on-error for this demo
ls /nonexistent_file 2>/dev/null
ls_exit=$?
set -e   # re-enable
echo "Exit code of failed 'ls': $ls_exit"   # Should be 2

# ── true and false builtins ──────────────────────────────────
# true always returns 0, false always returns 1
echo ""
true
echo "true  returns: $?"   # 0

set +e
false
false_code=$?
set -e
echo "false returns: $false_code"   # 1

# ── Checking exit codes with if ──────────────────────────────
echo ""
if true; then
    echo "true: condition passes (exit code 0)"
fi

if ! false; then
    echo "!false: condition passes (negated exit code 1 = 0)"
fi

# ── exit 0 / exit 1 in scripts ───────────────────────────────
# Use exit to terminate a script with a specific code
check_even() {
    local num=$1
    if (( num % 2 == 0 )); then
        return 0   # Success — number is even
    else
        return 1   # Failure — number is odd
    fi
}

echo ""
check_even 4 && echo "4 is even"
check_even 7 || echo "7 is odd"

# ── Chaining with && and || ──────────────────────────────────
# && runs next command only if previous succeeded
# || runs next command only if previous failed
echo ""
echo "Chain with && and ||:"
true  && echo "true &&  this runs"
false || echo "false || this runs"

# false && is skipped, and overall exit=1 triggers set -e
# We use || true to safely demonstrate it in strict mode
set +e
false && echo "false && this does NOT run"
set -e
echo "(the 'false &&' line didn't print, as expected)"