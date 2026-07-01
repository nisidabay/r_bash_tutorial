#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Modificar 01_hello_variables.sh
# ──────────────────────────────────────────────────────────────

read -p "Tu nombre: " name

fecha=$(date +%Y-%m-%d)

echo "Hola, ${name:-Invitado}! Hoy es $fecha."
