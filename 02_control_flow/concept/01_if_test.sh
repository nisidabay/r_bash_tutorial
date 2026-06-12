#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_if_test.sh — if, test, [ ] vs [[ ]] and condition types
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Basic if/then/fi ─────────────────────────────────────────
# if runs a command; if exit code is 0, the then block executes
if true; then
    echo "Basic if: true condition runs the then block"
fi

# ── test / [ ] vs [[ ]] ──────────────────────────────────────
# test EXPR or [ EXPR ] are the old POSIX way
# [[ EXPR ]] is the Bash way — more features, no word-splitting

echo ""
name="Alice"
# [ ] requires quoting: [ "$name" = "Alice" ]
if [ "$name" = "Alice" ]; then
    echo "[ ] test: name is Alice"
fi

# [[ ]] is safer — quoting not always needed
if [[ $name == "Alice" ]]; then
    echo "[[ ]] test: name is Alice (== preferred inside [[ ]])"
fi

# ── String tests ─────────────────────────────────────────────
echo ""
empty=""
if [[ -z "$empty" ]]; then
    echo "-z : string is empty (zero length)"
fi
if [[ -n "$name" ]]; then
    echo "-n : string is non-empty"
fi
if [[ "$name" != "Bob" ]]; then
    echo "!= : string is NOT Bob"
fi

# ── Numeric tests ────────────────────────────────────────────
# Use (( ... )) for arithmetic comparisons (more natural syntax)
# Inside [[ ]], use -eq, -ne, -lt, -le, -gt, -ge
echo ""
age=25
if (( age > 18 )); then
    echo "(( )) : $age is over 18 (arithmetic syntax)"
fi
if [[ $age -gt 18 ]]; then
    echo "[[ ]] -gt: $age is greater than 18"
fi
if [[ $age -lt 65 ]]; then
    echo "[[ ]] -lt: $age is less than 65"
fi

# ── File tests ───────────────────────────────────────────────
echo ""
script="$0"
if [[ -f "$script" ]]; then
    echo "-f : $script is a regular file"
fi
if [[ -r "$script" ]]; then
    echo "-r : $script is readable"
fi
if [[ -d /tmp ]]; then
    echo "-d : /tmp is a directory"
fi
if [[ -x "$(which bash)" ]]; then
    echo "-x : bash binary is executable"
fi