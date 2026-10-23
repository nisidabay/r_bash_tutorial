#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_hello_variables.sh — First script: hello world and variables
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'
# Setting IFS to only newline and tab characters prevents unexpected word
# splitting when variables contain spaces (like "San Miguel de Allende"). This is
# a subtle but critical best practice that many beginners miss.

# ── Hello, World! ────────────────────────────────────────────
# echo prints its arguments to stdout followed by a newline
echo "Hello, World!"

# ── Variables ────────────────────────────────────────────────
# Assign values with = (no spaces around the equals sign!)
name="Carlos"
age=42
city="San Miguel de Allende"

# Expand variables with $name or ${name} (braces optional for simple names)
# echo with multiple args inserts spaces between them
echo "My name is $name, I am $age years old."
echo "I live in" "${city}."

# ── Variable reassignment ────────────────────────────────────
# Variables are mutable — change them whenever you like
age=43
echo "Next year I will be $age."

# ── Unset variables ──────────────────────────────────────────
# With set -u, accessing unset variables is an error
# But we can use default values safely: ${VARNAME:-default}
echo "Favorite food: ${food:-tacos} (default used, variable not set)"

# ── Read-only variables ──────────────────────────────────────
# declare -r makes a variable read-only (immutable)
declare -r species="Human"
echo "Species: $species"
# species="Alien"  # This would error: readonly variable
