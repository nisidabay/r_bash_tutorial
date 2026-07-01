#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: Recomendación Climática
# ──────────────────────────────────────────────────────────────

echo "=== Recomendación Climática ==="

weather="${1:-}"

case "$weather" in
    sunny)
        echo "Usá protector solar y gafas de sol."
        ;;
    rainy)
        echo "Llevá un paraguas."
        ;;
    snowy)
        echo "Ponete botas y abrigo."
        ;;
    cloudy)
        echo "Podría llover, llevá un paraguas por las dudas."
        ;;
    windy)
        echo "Abrigate bien, hay viento fuerte."
        ;;
    foggy)
        echo "Manejá con cuidado, hay niebla."
        ;;
    ""|*)
        echo "Uso: $0 <clima>"
        echo "Climas válidos: sunny, rainy, snowy, cloudy, windy, foggy"
        ;;
esac
