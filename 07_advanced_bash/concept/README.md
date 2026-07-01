# 07 Advanced Bash — Namerefs, Case Flow Control, Getopts, and Templates

## Quick Start

```bash
bash 07_advanced_bash/concept/01_templates.sh
bash 07_advanced_bash/concept/02_case_flowing.sh
bash 07_advanced_bash/concept/05_nameref_increment.sh
bash 07_advanced_bash/concept/06_getopts_long.sh
bash 07_advanced_bash/concept/09_regex_ini_parser.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_templates.sh` | Robust script boilerplate | `set -euo pipefail`, logging levels, `cleanup` trap, `mktemp`, `main()` guard |
| `02_case_flowing.sh` | Case flow control: `;&` and `;&&` | `;&` (fallthrough), `;&&` (test next), `;;` (stop) |
| `03_case_flowing_ext.sh` | Case flow control extended | Chaining fallthrough then test-next on a single input |
| `04_case_flowing_validate.sh` | Multi-condition validation with `case` | `;&&` to set multiple boolean flags from one input |
| `05_nameref_increment.sh` | Nameref variables (`local -n`) | Pass-by-reference: increment, recursion, counters, progress tracking |
| `06_getopts_long.sh` | Long option parsing with `getopts` | `getopts ":-:..."`, nested `case` for `--option`, `--option=value` |
| `07_nameref_arrays.sh` | Array manipulation with namerefs | Pass arrays by reference, remove element, swap arrays |
| `08_nameref_compare.sh` | Array comparison with namerefs | `compare_contents_sorted`, `compare_exact_order`, sort-and-compare |
| `09_regex_ini_parser.sh` | INI/config file parser | `=~` regex validation, whitespace trimming, associative array storage |
| `10_store_input_array.sh` | Stdin-to-associative-array | Read pipe input into `declare -A`, key/value split by first space |
| `11_getopts_standard.sh` | Standard `getopts` argument parsing | `getopts ":vf:n:h"`, `OPTARG`, `OPTIND`, silent error handling |

## Common Patterns

```bash
# Nameref — modify a variable in the caller's scope
increment() {
    local -n ref="$1"
    ((ref++))
}
count=0
increment count  # count is now 1

# Case flow control — cascade through matching patterns
case "$input" in
    *[0-9]*) has_numbers=true ;;&
    *[a-zA-Z]*) has_letters=true ;;
esac

# Long option parsing with getopts
while getopts ":-:adho:vV" VAL; do
    case $VAL in
        -) case "$OPTARG" in
               verbose) VERBOSE=true ;;
               outfile=*) OFILE="${OPTARG#*=}" ;;
           esac ;;
    esac
done

# Logging levels
readonly LOG_ERROR=0 LOG_WARN=1 LOG_INFO=2 LOG_DEBUG=3
log() {
    local level="$1"; shift
    [[ $level -eq $LOG_DEBUG && "${DEBUG:-}" != "1" ]] && return
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2
}

# Associative array from config file
declare -A config
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# || -z "$line" ]] && continue
    [[ "$line" =~ ^[^=]+=.*$ ]] || continue
    key="${line%%=*}"; value="${line#*=}"
    config["$key"]="$value"
done <"$config_file"
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `11_getopts_standard.sh`

Tomá el script `11_getopts_standard.sh` y modificálo para que:

1. Agregá una opción `-o` que reciba un directorio de salida (`-o DIR`) y cree el directorio si no existe (`mkdir -p`).
2. Agregá una opción `-q` que active modo silencioso (suprima los mensajes de "Processing...").
3. Validá que si se pasa `-o`, el directorio sea escribible (`[[ -w "$dir" ]]`).

💡 Pista: modificá el optstring de la línea 52 de `:vf:n:h` a `:vf:n:o:qh`. Agregá `o)` y `q)` en el case. Para `o)`: `output_dir="$OPTARG"; mkdir -p "$output_dir"`. Para `q)`: `quiet=true`. Al final, usá `if [[ "$quiet" != true ]]; then echo "..."; fi`.

---

#### Desafío 2A — Basado en `02_case_flowing.sh`

Tomá el script `02_case_flowing.sh` y modificálo para que:

1. En lugar de analizar "iced_latte", analizá el primer argumento del script (`$1`).
2. Agregá más categorías: si contiene "sugar", "milk", "espresso", "decaf" — cada una debe aplicar `;&` o `;&&` apropiadamente para que una bebida como "decaf_soy_latte" active todos los flags correspondientes.
3. Al final, mostrá un resumen: "Es: caliente/frío, Con leche: sí/no, Cafeína: sí/no".

💡 Pista: usá `;&` para propiedades que siempre aplican (como "es una bebida") y `;&&` para seguir evaluando más patrones. Por ejemplo: `*decaf*) decaf=true ;;&` y `*milk*) milk=true ;;&`. Al final, un `echo` condicional muestra el resumen según los flags.

---

#### Desafío 3A — Basado en `05_nameref_increment.sh`

Tomá el script `05_nameref_increment.sh` y modificálo para que:

1. Agregá una función `append_to_array()` que reciba el nombre de un array (como nameref) y un elemento, y agregue ese elemento al array con `arr+=( "$elem" )`.
2. Agregá otra función `array_length()` que reciba un array por nameref y devuelva (en `$?`) 0 si tiene más de 3 elementos, 1 si tiene 3 o menos.
3. En `main()`, usá ambas funciones para agregar elementos a un array hasta que tenga 5 elementos, mostrando la longitud después de cada inserción.

💡 Pista: `append_to_array() { local -n arr="$1"; local elem="$2"; arr+=( "$elem" ); }`. Para `array_length()`, usá `local -n arr="$1"; ((${#arr[@]} > 3))`. Llamalo con `if array_length mi_array; then ...`.