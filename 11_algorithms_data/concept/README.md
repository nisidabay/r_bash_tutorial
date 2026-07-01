# 11 Algorithms & Data — ROT13, Fake Data, Search, and Random Generation

## Quick Start

```bash
bash 11_algorithms_data/concept/01_rot13.sh
bash 11_algorithms_data/concept/02_fake_data.sh
bash 11_algorithms_data/concept/03_linear_search.sh
bash 11_algorithms_data/concept/04_random_data.sh
bash 11_algorithms_data/concept/05_bubble_sort.sh
bash 11_algorithms_data/concept/06_binary_search.sh
bash 11_algorithms_data/concept/07_word_frequency.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_rot13.sh` | ROT13 encryption/decryption | `tr 'A-Za-z' 'N-ZA-Mn-za-m'`, user prompts for overwrite, `.enc` extension convention |
| `02_fake_data.sh` | Fake user data generator | `/dev/urandom` + `tr -dc 'a-zA-Z'`, `$RANDOM` for age, `mapfile` from process substitution |
| `03_linear_search.sh` | Linear search algorithm | Pass array elements as `"$@"`, iterate with `!array[@]` index, `break` on first match |
| `04_random_data.sh` | Random data generation cookbook | `$RANDOM` range patterns, `/dev/urandom` passwords, random dates, hex colors, IPs, filenames |
| `05_bubble_sort.sh` | Bubble sort with nameref | `local -n` for array swap, nested loops, in-place sorting, string comparison |
| `06_binary_search.sh` | Binary search on sorted array | Divide and conquer, `((lo <= hi))` loop, logarithmic search |
| `07_word_frequency.sh` | Word frequency counter | `declare -A freq`, tr lowercasing, sed cleanup, sort -rn |

## Common Patterns

```bash
# ROT13 — tr-based substitution cipher
tr 'A-Za-z' 'N-ZA-Mn-za-m' < input.txt > output.enc

# Random string from /dev/urandom
random_str=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12)

# Random number in range [min, max)
random_in_range=$((RANDOM % (max - min) + min))

# Random element from array
options=("apple" "banana" "cherry")
random_index=$((RANDOM % ${#options[@]}))
selected="${options[$random_index]}"

# Random date between two dates
start=$(date -ud "2023-01-01" +%s)
end=$(date -ud "2023-12-31" +%s)
random_ts=$((start + RANDOM % (end - start)))
random_date=$(date -ud "@$random_ts" +"%Y-%m-%d")

# Linear search
linear_search() {
    local target="$1"; shift
    local -a arr=("$@")
    for i in "${!arr[@]}"; do
        [[ "${arr[i]}" == "$target" ]] && echo "$i" && return 0
    done
    echo -1
}

# Generate fake data rows into an array
mapfile -t data < <(
    for ((i=0; i<count; i++)); do
        generate_row
    done
)
```

## Basado en lo aprendido hasta ahora, creá un script que...

---

#### Desafío 1B — Basado en `01_rot13.sh`, `02_fake_data.sh`, y `03_linear_search.sh`

Basado en lo que viste en `02_fake_data.sh`, `03_linear_search.sh`, y `01_rot13.sh`, creá un script que:

1. Genere 15 registros de usuarios falsos (nombre, edad, email) usando el patrón de `02_fake_data.sh`.
2. Almacene los registros en un array indexado y también en un array asociativo clave=email.
3. Implementá una función `buscar_por_email()` que use linear search (como en `03_linear_search.sh`) sobre el array indexado para encontrar un usuario por email.
4. Agregá una opción para codificar los emails con ROT13 (usando `tr 'A-Za-z' 'N-ZA-Mn-za-m'` como en `01_rot13.sh`) antes de mostrar.

💡 Pista: arrancá copiando `02_fake_data.sh` y modificá `generate_fake_user()` para que también devuelva email. Usá `mapfile -t usuarios < <(for ...)`. Para la búsqueda, copiá la función `linear_search()` de `03_linear_search.sh` pero comparando el campo email. Para ROT13: `echo "$email" | tr 'A-Za-z' 'N-ZA-Mn-za-m'`.

---

#### Desafío 2A — Basado en `04_random_data.sh`

Tomá el script `04_random_data.sh` y modificálo para que:

1. Agregá una función `generar_matricula()` que genere una matrícula estilo "ABC-1234" (3 letras mayúsculas, guión, 4 dígitos).
2. Agregá una función `generar_telefono()` que genere un número tipo "+54 9 11 XXXX-XXXX" con los últimos 8 dígitos aleatorios.
3. Agregá un menú (usando el `select` que ya tiene el script al final) que permita elegir qué tipo de dato generar, y genere 10 ejemplos de una vez.

💡 Pista: para la matrícula: `letras=$(LC_ALL=C tr -dc 'A-Z' </dev/urandom | head -c 3); numeros=$(printf "%04d" $((RANDOM % 10000))); echo "${letras}-${numeros}"`. Para el teléfono: `num=$(printf "%04d" $((RANDOM % 10000))); echo "+54 9 11 1234-${num}"`. Agregá estas funciones al array `functions` del menú (línea 126-137).

---

#### Desafío 3A — Basado en `01_rot13.sh`

Tomá el script `01_rot13.sh` y modificálo para que:

1. En lugar de solo ROT13, ofrecé tres modos con `-e` (ROT13 encode), `-d` (ROT13 decode = mismo comando), y `-r` (ROT47 — similar pero para ASCII imprimible: `tr '!-~' 'P-~!-O'`).
2. Agregá validación de que el archivo de entrada no esté vacío (`[[ -s "$input_file" ]]`).
3. Si se pasa `-r` modo ROT47, usá el comando `tr` correspondiente.

💡 Pista: agregá `-r` al case de validación del modo. Definí una variable `tr_cmd` que contenga `'A-Za-z' 'N-ZA-Mn-za-m'` para rot13 y `'!-~' 'P-~!-O'` para rot47. Usá `echo "$tr_cmd"` en la función `perform_rot13` en lugar de los valores fijos. Agregá `[[ -s "$input_file" ]] || { echo "Error: archivo vacío"; exit 1; }` antes de procesar.