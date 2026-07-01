# 02 Control Flow — Conditionals and Loops

## Quick Start

```bash
bash 02_control_flow/concept/01_if_test.sh
bash 02_control_flow/concept/02_elif_else.sh
bash 02_control_flow/concept/03_for_loop.sh
bash 02_control_flow/concept/04_while_until.sh
bash 02_control_flow/concept/05_case_basic.sh
bash 02_control_flow/concept/06_break_continue.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_if_test.sh` | `if`/`then`/`fi`, `test`, `[[ ]]`, `(( ))` | `[[ -f "$file" ]]`, `(( age > 18 ))`, string/numeric/file tests |
| `02_elif_else.sh` | Multi-branch conditions | `if ... elif ... else ... fi`, `&&`/`\|\|` combinators |
| `03_for_loop.sh` | All for loop flavors | `for i in {1..5}`, `for file in *.sh`, C-style `for ((i=0; i<5; i++))` |
| `04_while_until.sh` | While and until loops | `while read -r line`, `until (( x > n ))`, `while true` with break |
| `05_case_basic.sh` | Pattern matching with case | `case "$var" in pattern) cmd ;; esac`, wildcards, CLI parsing |
| `06_break_continue.sh` | Loop control | `break`, `break N`, `continue`, `continue N` |

## Common Patterns

```bash
# String test with [[ ]]
if [[ -z "$var" ]]; then echo "empty"; fi

# Numeric test with (( ))
if (( count > 10 && count < 100 )); then ...

# Safe file loop
for file in *.txt; do
    [[ -f "$file" ]] || continue
    echo "Processing: $file"
done

# Read lines from a file
while IFS= read -r line; do
    echo "$line"
done < input.txt

# CLI argument parsing with case
case "$1" in
    -h|--help) show_help; exit 0 ;;
    -v|--verbose) verbose=true; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
esac

# Nested loop exit
for outer in a b c; do
    for inner in 1 2 3; do
        [[ "$outer" == "b" ]] && break 2
    done
done
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `01_if_test.sh`

Tomá el script `01_if_test.sh` y modificálo para que:

1. En lugar de tests fijos, pedí al usuario que ingrese un path (archivo o directorio) con `read -p`.
2. Mostrá un reporte que indique: si existe (`-e`), si es archivo (`-f`) o directorio (`-d`), si es legible (`-r`), y si es ejecutable (`-x`).
3. Usá `elif` para que el mensaje cambie según el tipo: "Es un directorio legible" vs "Es un script ejecutable" vs "No existe".

💡 Pista: agregá `read -p "Path a verificar: " path` al inicio del `main()`. Después usá `if [[ -e "$path" ]]; then` con `[[ -f "$path" ]]` y `[[ -d "$path" ]]` dentro. Los tests de `-r` y `-x` van como condiciones adicionales.

---

#### Desafío 2A — Basado en `03_for_loop.sh` + `06_break_continue.sh`

Tomá el script `03_for_loop.sh` y modificálo para que:

1. Itere sobre todos los archivos `*.txt` del directorio actual.
2. Saltee los que no sean archivos regulares con `continue`.
3. Si encuentra un archivo de más de 1 KB, muestre su nombre y tamaño, y detenga el proceso con `break` (simulando que "encontró uno grande, no hace falta seguir").

💡 Pista: arrancá con `for file in *.txt; do` y dentro usá `[[ -f "$file" ]] || continue`. Para el tamaño: `size=$(wc -c < "$file")` y `if (( size > 1024 )); then ...; break; fi`. El patrón `continue`/`break` lo viste en `06_break_continue.sh`.

---

#### Desafío 3A — Basado en `05_case_basic.sh`

Tomá el script `05_case_basic.sh` y modificálo para que:

1. En lugar del `weather` fijo, tomá el primer argumento del script como entrada (`$1`).
2. Agregá más casos: `cloudy`, `windy`, `foggy`, cada uno con su recomendación.
3. Usá el patrón `*)` como fallback para mostrar el uso del script si no se pasa argumento o si el clima es desconocido.

💡 Pista: cambiá `weather="sunny"` por `local weather="${1:-}"`. Al inicio del `case`, agregá `""|*)` que muestre "Uso: $0 <clima>". Los casos nuevos van antes del `*)`.