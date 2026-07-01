#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_quoting.sh — Single vs double quotes and escaping
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Double quotes: variable expansion ────────────────────────
# "$var" expands the variable — use this by default for strings
name="Alice"
echo "Double quotes expand: Hello, $name!"
echo "Also works with ${name} — brace form for ${name}ext"

# ── Single quotes: literal strings ───────────────────────────
# '$var' treats everything literally — NOTHING is expanded
# shellcheck disable=SC2016  # intentional: showing single quotes prevent expansion
echo 'Single quotes: Hello, $name! (literal, no expansion)'
# shellcheck disable=SC2016  # intentional: showing single quotes prevent expansion
echo 'Even backticks `pwd` and $dollars are literal'
echo 'Single quotes cannot contain single quotes — not even escaped'

# ── Mixing quotes ────────────────────────────────────────────
# Concatenate quoted strings to mix literal and expanded parts
echo 'Hello' "$name" ', welcome to' "$(pwd)"

# ── Escaping with backslash ──────────────────────────────────
# Use \ to escape special chars inside double quotes
echo "He said \"Hello\" and paid \$5.00"
# Outside quotes, backslash escapes the next character
echo The cost is \$5.00

# ── $'...' for special characters ────────────────────────────
# $'string' interprets ANSI-C escape sequences
echo $'Line 1\nLine 2 (newline via $\'...\')'
echo $'Tab\tseparated\tvalues'
echo $'Bell: \a (may not hear in all terminals)'

# ── When to use each ─────────────────────────────────────────
# Double quotes: when you WANT expansion of $var, $(cmd), or $((expr))
# Single quotes: when you want TEXT, e.g., literal regex or SQL
# $'...': when you need escape sequences like \n \t \0
# No quotes ($var): only when you EXPLICITLY want word splitting/globbing