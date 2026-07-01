#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 05_case_basic.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Analizar el primer argumento como clima con case,
# agregar más casos, y mostrar uso con *) como fallback.
# ──────────────────────────────────────────────────────────────

echo "=== Recomendación Climática ==="

# TODO: Obtener el clima del primer argumento con valor por defecto vacío
# local weather="${1:-}"

# TODO: Usar case para evaluar $weather

# Casos: sunny, rainy, snowy, cloudy, windy, foggy
# Cada uno con su recomendación

# TODO: Si el argumento está vacío o es desconocido (*), mostrar:
# "Uso: $0 <clima>"

exit 0
