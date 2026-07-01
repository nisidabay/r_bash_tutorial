# 01 Basics — Variables, Quoting, Exit Codes, and Output

## Quick Start

```bash
bash 01_basics/concept/01_hello_variables.sh
bash 01_basics/concept/02_quoting.sh
bash 01_basics/concept/03_exit_codes.sh
bash 01_basics/concept/04_shebang_strict.sh
bash 01_basics/concept/05_echo_printf.sh
bash 01_basics/concept/06_ifs.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_hello_variables.sh` | Variables, assignment, expansion | `name="value"`, `$var`, `${var:-default}` |
| `02_quoting.sh` | Single vs double quotes, escaping | `"$var"` expands, `'$var'` is literal, `$'\n'` escapes |
| `03_exit_codes.sh` | Exit codes, `$?`, `true`/`false` | `$?`, `exit 0`, `&&`/`\|\|` chaining |
| `04_shebang_strict.sh` | Shebang, `set -euo pipefail` | `#!/usr/bin/env bash`, strict mode combo |
| `05_echo_printf.sh` | `echo` vs `printf` formatting | `printf "%s %d %.2f"`, alignment |
| `06_ifs.sh` | IFS and word splitting | `IFS=:`, `IFS=$'\n\t'`, save/restore pattern |

## Common Patterns

```bash
# Safe variable with default
name="${1:-World}"

# Strict mode boilerplate
set -euo pipefail
IFS=$'\n\t'

# Save and restore IFS for parsing
OLD_IFS="$IFS"
IFS=":"
# ... parse fields ...
IFS="$OLD_IFS"

# Format a table
printf "%-20s %5s\n" "Name" "Score"
printf "%-20s %5d\n" "Alice" 95

# Check exit code safely with set -e
set +e
potentially_failing_command
exit_code=$?
set -e
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `01_hello_variables.sh`

Tomá el script `01_hello_variables.sh` y modificálo para que:

1. En lugar de `name="Carlos"` fijo, pida el nombre al usuario con `read -p` y lo guarde en `name`.
2. Use `${name:-Invitado}` para que si el usuario no ingresa nada, se muestre "Invitado".
3. Al final, declare una variable `fecha` con la fecha actual usando `$(date +%Y-%m-%d)` y la incluya en el mensaje final.

💡 Pista: reemplazá la línea 14 (`name=...`) por `read -p "Tu nombre: " name` y agregá `${name:-Invitado}` en el echo de la línea 20. Para la fecha, agregá una línea como `fecha=$(date +%Y-%m-%d)` y referenciala en el mensaje.

---

#### Desafío 2A — Basado en `05_echo_printf.sh`

Tomá el script `05_echo_printf.sh` y modificálo para que:

1. En lugar de la tabla de ejemplo "Name/Score", mostrá una tabla de 3 productos con nombre, precio en centavos (entero) y cantidad.
2. Usá `printf` con `%3d` para la cantidad y formato manual para el precio (ej: `$((precio / 100)).$((precio % 100))`).
3. Agregá una fila de total al final que sume los precios × cantidades.

💡 Pista: copiá el bloque de la tabla (líneas 38-44) y cambiá las columnas a algo como `"│ %-15s │ %4d.%02d │ %3d │"`. Usá `precio_ent=$((precio / 100))` y `precio_dec=$((precio % 100))` para formatear.

---

#### Desafío 3A — Basado en `06_ifs.sh`

Tomá el script `06_ifs.sh` y modificálo para que:

1. En lugar de parsear una cadena fija `path_entry`, pedile al usuario que ingrese una línea con campos separados por coma.
2. Parseá los campos usando `IFS=","` y mostralos numerados.
3. Volvé a unir los campos en una sola cadena con `IFS=" | "` y mostrala.

💡 Pista: reemplazá la línea 38 (`path_entry=...`) por `read -p "Ingresá campos separados por coma: " entrada`. Después del parseo con `IFS=","`, usá `IFS=" | "` y `echo "${colors[*]}"` (pero con tu variable en lugar de `colors`).