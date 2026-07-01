# 07d printf Deep Dive — Format Specifiers, Dates, Alignment, and ANSI

## Quick Start

```bash
bash 07d_printf_deep_dive/concept/01_printf_format_specifiers.sh
bash 07d_printf_deep_dive/concept/02_printf_date_align.sh
bash 07d_printf_deep_dive/concept/03_printf_advanced.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_printf_format_specifiers.sh` | Format specifiers: `%s`, `%d`, `%f`, `%x`, `%o` | Padding, alignment, reusing arguments, dynamic width |
| `02_printf_date_align.sh` | Date formatting with `%(datefmt)T` | `printf "%(%Y-%m-%d)T" -1`, column alignment, dynamic width |
| `03_printf_advanced.sh` | Escape sequences, ANSI colors, column formatting | `\033[31m`, `%-*s` dynamic width, `%(datefmt)T` everywhere |

## Common Patterns

```bash
# Table with variable-width columns
printf "%-20s %8s %s\n" "Name" "Age" "Country"
printf "%-20s %8d %s\n" "Alice" 30 "Uruguay"

# Date without forking date(1)
printf "Today: %(%Y-%m-%d)T\n" -1

# Dynamic width from variable
width=20
printf "|%*s|\n" "$width" "centered-ish"

# Color output
printf "\033[32m%s\033[0m\n" "green text"

# Padding with zeros
printf "ID: %04d\n" 42

# Repeat characters
printf "%0.s=" {1..40}
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `02_printf_date_align.sh`

Tomá el script `02_printf_date_align.sh` y modificálo para que:

1. En lugar de la tabla de personas, mostrá una tabla de archivos con nombre, tamaño (en KB con 1 decimal, usando `%8.1f`) y fecha de modificación.
2. Usá `%(datefmt)T` con `%Y-%m-%d` para las fechas.
3. El ancho de la columna de nombres debe ser dinámico: tomalo del primer argumento del script, con default 25.

💡 Pista: cambiá el array por archivos simulados tipo `("docs.txt:2048:1700000000" ...)`. Usá `IFS=:` para separar. Para el tamaño: `kb=$(echo "scale=1; $bytes / 1024" | bc)` o redondeá con `$(( (bytes + 512) / 1024 ))` para entero. El ancho dinámico: `local w=${1:-25}` y usá `%-*s` en printf.

---

#### Desafío 2A — Basado en `03_printf_advanced.sh`

Tomá el script `03_printf_advanced.sh` y modificálo para que:

1. Agregá un reporte de colores: mostrá 16 colores ANSI básicos (30-37 y 90-97 como brillantes) en una tabla de 2 columnas.
2. Cada celda debe tener el color correspondiente aplicado al texto.
3. Usá `%-20s` para alinear los nombres de color a la izquierda.

💡 Pista: creá un array `colores=("Negro" "Rojo" "Verde" ...)`. Iterá con `for i in "${!colores[@]}"; do cod=$((30 + i)); printf "\033[${cod}m%-20s\033[0m" "${colores[i]}"; done`.
