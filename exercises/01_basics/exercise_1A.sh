#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 01_hello_variables.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Modificar 01_hello_variables.sh para que pida el
# nombre al usuario, use un valor por defecto y agregue la fecha.
# ──────────────────────────────────────────────────────────────

# ── Solicitar nombre al usuario ──────────────────────────────
# TODO: Usar read -p para pedir el nombre y guardarlo en name

# ── Usar valor por defecto ────────────────────────────────────
# TODO: Usar ${name:-Invitado} en el mensaje de saludo

# ── Obtener fecha actual ──────────────────────────────────────
# TODO: Capturar la fecha con $(date +%Y-%m-%d) en variable fecha

# ── Mostrar mensaje final ─────────────────────────────────────
echo "Hola, ${name:-Invitado}! Hoy es $(date +%Y-%m-%d)."

exit 0
