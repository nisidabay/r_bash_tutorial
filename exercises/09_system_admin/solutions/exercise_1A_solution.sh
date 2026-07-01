#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Menú de herramientas de red
# ──────────────────────────────────────────────────────────────

echo "=== 🛠️  Herramientas de Red ==="

# Verificar comandos
for cmd in ping nc curl traceroute; do
    command -v "$cmd" &>/dev/null || echo "⚠ Advertencia: '$cmd' no está instalado."
done

MENU_OPTIONS=(
    "Ping a servidor"
    "Escaneo de puertos (local)"
    "Mostrar IP pública"
    "Traceroute"
    "Salir"
)

PS3="Elegí una opción: "
select choice in "${MENU_OPTIONS[@]}"; do
    case "$choice" in
        "Ping a servidor")
            read -p "Servidor: " server
            ping -c 3 "$server" 2>&1 || true
            ;;
        "Escaneo de puertos (local)")
            echo "Escaneando puertos comunes en localhost..."
            for port in 22 80 443 8080; do
                timeout 1 bash -c "echo >/dev/tcp/localhost/$port" 2>/dev/null &&
                    echo "  Puerto $port: ABIERTO" || echo "  Puerto $port: cerrado"
            done
            ;;
        "Mostrar IP pública")
            curl -s ifconfig.me 2>/dev/null && echo "" || echo "No se pudo obtener IP pública."
            ;;
        "Traceroute")
            read -p "Destino: " destino
            traceroute "$destino" 2>&1 || true
            ;;
        "Salir")
            echo "👋 ¡Hasta luego!"
            break
            ;;
        *)
            echo "❌ Opción inválida: $REPLY"
            ;;
    esac
    echo ""
done
