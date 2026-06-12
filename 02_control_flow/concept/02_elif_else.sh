#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_elif_else.sh — Multi-branch conditions with elif and else
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── if / else ─────────────────────────────────────────────────
# else runs when the if condition fails
password="secret"
if [[ "$password" == "secret" ]]; then
    echo "Access granted (correct password)"
else
    echo "Access denied (wrong password)"
fi

# ── if / elif / else ─────────────────────────────────────────
# elif chains multiple conditions — runs first match only
echo ""
score=85

if (( score >= 90 )); then
    echo "Grade: A"
elif (( score >= 80 )); then
    echo "Grade: B"
elif (( score >= 70 )); then
    echo "Grade: C"
elif (( score >= 60 )); then
    echo "Grade: D"
else
    echo "Grade: F"
fi

# ── Combining tests with && (AND) and || (OR) ────────────────
echo ""
age=25
has_license=true

if (( age >= 18 )) && [[ "$has_license" == true ]]; then
    echo "Can drive: age $age and has license"
fi

day="Saturday"
if [[ "$day" == "Saturday" ]] || [[ "$day" == "Sunday" ]]; then
    echo "It's the weekend!"
fi

# ── Nested conditions ────────────────────────────────────────
echo ""
user="admin"
file="/etc/hosts"

if [[ -f "$file" ]]; then
    if [[ "$user" == "root" ]] || [[ "$user" == "admin" ]]; then
        echo "$user can edit $file"
    else
        echo "$user cannot edit $file (insufficient permissions)"
    fi
else
    echo "$file does not exist"
fi

# ── Inline if with && / || ───────────────────────────────────
# Use && and || for simple one-line conditionals
echo ""
[[ -d /tmp ]] && echo "/tmp exists (inline &&)"
[[ -d /nonexistent ]] || echo "/nonexistent missing (inline ||)"