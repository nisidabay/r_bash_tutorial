# 07b Namerefs & Data — Variables by Reference, Arrays, and Storage

## Quick Start

```bash
bash 07b_namerefs_data/concept/01_nameref_increment.sh
bash 07b_namerefs_data/concept/02_nameref_arrays.sh
bash 07b_namerefs_data/concept/03_nameref_compare.sh
bash 07b_namerefs_data/concept/04_store_input_array.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_nameref_increment.sh` | Nameref variables (`local -n`) | Pass-by-reference: increment, recursion, counters, progress tracking |
| `02_nameref_arrays.sh` | Array manipulation with namerefs | Pass arrays by reference, remove element, swap arrays |
| `03_nameref_compare.sh` | Array comparison with namerefs | `compare_contents_sorted`, `compare_exact_order`, sort-and-compare |
| `04_store_input_array.sh` | Stdin-to-associative-array | Read pipe input into `declare -A`, key/value split by first space |

## Common Patterns

```bash
# Nameref — modify a variable in the caller's scope
increment() {
    local -n ref="$1"
    ((ref++))
}
count=0
increment count  # count is now 1

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

#### Desafío 1A — Basado en `01_nameref_increment.sh`

Tomá el script `01_nameref_increment.sh` y modificálo para que:

1. Agregá una función `append_to_array()` que reciba el nombre de un array (como nameref) y un elemento, y agregue ese elemento al array con `arr+=( "$elem" )`.
2. Agregá otra función `array_length()` que reciba un array por nameref y devuelva (en `$?`) 0 si tiene más de 3 elementos, 1 si tiene 3 o menos.
3. En `main()`, usá ambas funciones para agregar elementos a un array hasta que tenga 5 elementos, mostrando la longitud después de cada inserción.

💡 Pista: `append_to_array() { local -n arr="$1"; local elem="$2"; arr+=( "$elem" ); }`. Para `array_length()`, usá `local -n arr="$1"; ((${#arr[@]} > 3))`. Llamalo con `if array_length mi_array; then ...`.
