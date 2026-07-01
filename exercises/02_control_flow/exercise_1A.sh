#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 01_if_test.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Pedir un path al usuario y mostrar un reporte con
# -e, -f, -d, -r, -x usando elif para diferentes mensajes.
# ──────────────────────────────────────────────────────────────

echo "=== Verificador de Path ==="

# TODO: Pedir un path al usuario con read -p
# read -p "Path a verificar: " path

# TODO: Verificar si existe (-e). Si no existe, mostrar "No existe"
# y salir.

# TODO: Si existe, determinar si es archivo (-f) o directorio (-d)

# TODO: Verificar si es legible (-r) y ejecutable (-x)

# TODO: Usar elif para mensajes distintos según el tipo:
# "Es un directorio legible" / "Es un script ejecutable" / etc.

exit 0
