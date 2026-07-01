#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B_solution.sh — Solución: Parser clave=valor con arrays
# ──────────────────────────────────────────────────────────────

main() {
    local -A config
    local lines=()

    # Leer datos desde here-doc
    mapfile -t lines << 'EOF'
usuario=admin
puerto=8080
host=localhost
basedatos=mi_app
debug=true
EOF

    # Procesar cada línea con parameter expansion
    local line key val
    for line in "${lines[@]}"; do
        key="${line%%=*}"
        val="${line#*=}"
        config["$key"]="$val"
    done

    # Mostrar como tabla
    echo "=== Configuración ==="
    printf "│ %-15s │ %-15s │\n" "Clave" "Valor"
    printf "│%s│\n" "──────────────────────────────────"
    for key in "${!config[@]}"; do
        printf "│ %-15s │ %-15s │\n" "$key" "${config[$key]}"
    done
}

main "$@"
