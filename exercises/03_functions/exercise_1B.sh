#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B.sh — Basado en 05_main_pattern.sh y 06_source_include.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Crear lib_validacion.sh y validador.sh
# ──────────────────────────────────────────────────────────────
# NOTA: Este ejercicio requiere crear DOS archivos:
#   lib_validacion.sh  — Biblioteca de validación
#   validador.sh       — Script principal que sourcea la library
# ──────────────────────────────────────────────────────────────

# Parte 1: lib_validacion.sh
# TODO: Crear funciones:
#   es_numero()  — return 0 si $1 es dígito
#   es_email()   — return 0 si $1 contiene @
#   no_vacio()   — return 0 si $1 no está vacío
# Cada función debe usar local y devolver códigos de retorno.

# Parte 2: validador.sh
# TODO: Script que sourcee lib_validacion.sh
# TODO: Tenga un main() con el patrón BASH_SOURCE guard
# TODO: Valide argumentos recibidos por línea de comandos
# TODO: Reporte cuáles pasaron cada validación

echo "Completá este ejercicio creando lib_validacion.sh y validador.sh"
exit 1
