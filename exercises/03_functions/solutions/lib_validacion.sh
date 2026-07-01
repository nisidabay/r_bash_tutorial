#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# lib_validacion.sh — Biblioteca de validación
# ──────────────────────────────────────────────────────────────
# This file is meant to be SOURCED, not executed directly.
# No set -euo pipefail here — it inherits the caller's settings.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── es_numero: return 0 si $1 es un número (dígito) ──────────
es_numero() {
    local valor="$1"
    [[ "$valor" =~ ^[0-9]+$ ]]
}

# ── es_email: return 0 si $1 contiene @ ──────────────────────
es_email() {
    local valor="$1"
    [[ "$valor" == *@* ]]
}

# ── no_vacio: return 0 si $1 no está vacío ───────────────────
no_vacio() {
    local valor="$1"
    [[ -n "$valor" ]]
}

# Only run if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "This is a library — source it, don't execute it!" >&2
    echo "  Usage: source ${BASH_SOURCE[0]}" >&2
    exit 1
fi
