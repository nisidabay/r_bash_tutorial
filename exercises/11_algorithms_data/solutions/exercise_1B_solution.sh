#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B_solution.sh — Solución: Usuarios falsos con búsqueda
# ──────────────────────────────────────────────────────────────

generate_fake_user() {
    local name age email
    name=$(LC_ALL=C tr -dc 'a-zA-Z' </dev/urandom | head -c 5)
    age=$((RANDOM % 60 + 20))
    email="${name,,}@example.com"
    echo "$name,$age,$email"
}

rot13_encode() {
    echo "$1" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

buscar_por_email() {
    local target="$1"
    shift
    local -a users=("$@")
    local i

    for i in "${!users[@]}"; do
        if [[ "${users[$i]}" == *"$target"* ]]; then
            echo "$i"
            return 0
        fi
    done
    echo "-1"
    return 1
}

main() {
    local num_users=15
    local use_rot13=false

    [[ "${1:-}" == "-r" ]] && use_rot13=true

    local -a usuarios
    local -A email_index

    mapfile -t usuarios < <(
        for ((i=1; i<=num_users; i++)); do
            generate_fake_user
        done
    )

    echo "=== Usuarios Generados ==="
    for user in "${usuarios[@]}"; do
        local email="${user##*,}"
        email_index["$email"]="$user"

        if [[ "$use_rot13" == true ]]; then
            local name="${user%%,*}"
            local age="${user#*,}"
            age="${age%,*}"
            echo "$name,$age,$(rot13_encode "$email")"
        else
            echo "$user"
        fi
    done

    echo ""
    echo "Buscando primer email..."
    local first_email="${usuarios[0]##*,}"
    local result
    result=$(buscar_por_email "$first_email" "${usuarios[@]}")
    if [[ "$result" != "-1" ]]; then
        echo "✅ Email encontrado en índice $result"
    fi
}

main "$@"
