#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 03_select_menu.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Menú de herramientas de red con verificación de
# comandos y opción interactiva de ping.
# ──────────────────────────────────────────────────────────────

echo "=== 🛠️  Herramientas de Red ==="

# TODO: Verificar comandos necesarios (ping, nc, curl, traceroute)
# for cmd in ping nc curl traceroute; do
#     command -v "$cmd" &>/dev/null || echo "Falta: $cmd"
# done

# TODO: Definir MENU_OPTIONS con:
# "Ping a servidor", "Escaneo de puertos (local)", "Mostrar IP pública",
# "Traceroute", "Salir"

# TODO: Crear loop select con case para cada opción
# Para "Ping a servidor": pedir dirección con read -p y ejecutar ping -c 3

PS3="Elegí una opción: "
# select choice in "${MENU_OPTIONS[@]}"; do
#     case "$choice" in ... esac
# done

exit 0
