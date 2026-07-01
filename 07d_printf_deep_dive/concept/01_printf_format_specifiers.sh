#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_printf_format_specifiers.sh — printf format specifiers
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# printf interpreta el primer argumento como FORMATO.
# Los argumentos restantes se insertan donde aparecen los
# especificadores de formato (%s, %d, %f, etc.).

echo "=== %s — String ==="
printf "Hola, %s!\n" "Mundo"
printf "Nombre: %s | Edad: %s\n" "Carlos" "42"

echo ""
echo "=== %d — Entero ==="
printf "Decimal: %d\n" 42
printf "Con signo: %+d\n" 42
printf "Padding zeros: %05d\n" 42
printf "Alineado izq: %-5d|\n" 42

echo ""
echo "=== %f — Flotante ==="
printf "Flotante: %f\n" 3.141592
printf "2 decimales: %.2f\n" 3.141592
printf "Ancho 8: %8.2f\n" 3.141592
printf "Alineado izq: %-8.2f|\n" 3.141592

echo ""
echo "=== %x / %o — Hexadecimal / Octal ==="
printf "Hex (minus): %x\n" 255
printf "Hex (mayus): %X\n" 255
printf "Octal: %o\n" 255
printf "Padding: %04x\n" 255

echo ""
echo "=== Varios argumentos ==="
printf "%s=%d\n" "uno" 1 "dos" 2 "tres" 3
# Si faltan args, printf reusa o pone 0/"" según el tipo
printf ">>>%s<<<\n" a b     # dos líneas
printf ">>>%s<<<\n" a       # una línea, espera otro arg

echo ""
echo "=== Ancho dinámico con * ==="
printf "%*s\n" 20 "derecha"
printf "%-*s\n" 20 "izquierda"
printf "%*.*f\n" 10 2 3.141592
