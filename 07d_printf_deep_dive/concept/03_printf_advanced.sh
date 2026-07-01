#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_printf_advanced.sh — printf: escape codes, columnas, colores
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# printf entiende secuencias de escape como \n, \t, \r
# y también puede formatear columnas desde stdin.

echo "=== Secuencias de escape ==="
printf "Línea 1\nLínea 2\nLínea 3\n"
printf "Columna1\tColumna2\tColumna3\n"
printf "\\r retorno de carro (sobreescribe)\n"

echo ""
echo "=== Columnas desde un array ==="
datos=("Carlos:42:Argentina" "Ana:35:México" "Pedro:28:Chile")
printf "%-15s %5s  %-12s\n" "Nombre" "Edad" "País"
printf "%-15s %5s  %-12s\n" "------" "----" "------"
for linea in "${datos[@]}"; do
    IFS=: read -r nombre edad pais <<< "$linea"
    printf "%-15s %5d  %-12s\n" "$nombre" "$edad" "$pais"
done

echo ""
echo "=== Colores con printf (ANSI) ==="
printf "\033[31mRojo\033[0m\n"
printf "\033[32mVerde\033[0m\n"
printf "\033[33mAmarillo\033[0m\n"
printf "\033[34mAzul\033[0m\n"
printf "\033[1mNegrita\033[0m\n"
printf "\033[4mSubrayado\033[0m\n"

echo ""
echo "=== printf vs echo para portabilidad ==="
# echo -e no es portable; printf sí lo es.
# En Bash, siempre preferí printf para formato.

echo ""
echo "=== Resumen: printf flags ==="
printf "%-12s %-8s %s\n" "Flag" "Tipo" "Ejemplo"
printf "%-12s %-8s %s\n" "%s" "string"  "printf \"%s\" \"hola\""
printf "%-12s %-8s %s\n" "%d" "entero"  "printf \"%d\" 42"
printf "%-12s %-8s %s\n" "%f" "float"   "printf \"%.2f\" 3.14"
printf "%-12s %-8s %s\n" "%x" "hex"     "printf \"%x\" 255"
printf "%-12s %-8s %s\n" "%X" "HEX"     "printf \"%X\" 255"
printf "%-12s %-8s %s\n" "%o" "octal"   "printf \"%o\" 255"
printf "%-12s %-8s %s\n" "%*s" "ancho"  "printf \"%*s\" 10 \"x\""
printf "%-12s %-8s %s\n" "%()T" "fecha" "printf \"%(%Y)T\" -1"
