#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B.sh — Basado en 02_fake_data.sh, 03_linear_search.sh,
#                  01_rot13.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Generar 15 usuarios falsos, almacenar en arrays,
# implementar búsqueda por email, y opción ROT13.
# ──────────────────────────────────────────────────────────────

# TODO: Copiar generate_fake_user() de 02_fake_data.sh
# Debe generar nombre, edad y email

# TODO: Implementar buscar_por_email()
# Usar linear search sobre el array indexado

# TODO: Implementar rot13_encode()
# echo "$email" | tr 'A-Za-z' 'N-ZA-Mn-za-m'

main() {
    # TODO: Generar 15 usuarios con mapfile
    # Almacenar en array indexado Y array asociativo clave=email

    # TODO: Buscar un email específico (ej: el primer usuario)

    # TODO: Opción para codificar emails con ROT13
    local use_rot13=false
    # Si se pasa -r como argumento, activar ROT13
}

main "$@"
