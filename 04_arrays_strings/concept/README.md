# 04 Arrays & Strings — Indexed, Associative, Iteration, Expansion

## Quick Start

```bash
bash 04_arrays_strings/concept/01_indexed_arrays.sh
bash 04_arrays_strings/concept/02_associative_arrays.sh
bash 04_arrays_strings/concept/03_iteration.sh
bash 04_arrays_strings/concept/04_mapfile.sh
bash 04_arrays_strings/concept/05_parameter_expansion.sh
bash 04_arrays_strings/concept/06_here_docs.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_indexed_arrays.sh` | Indexed arrays | `arr=(a b c)`, `${arr[@]}`, `${#arr[@]}`, `arr+=(d)`, `${arr[@]:1:2}` |
| `02_associative_arrays.sh` | Associative arrays | `declare -A map`, `map[key]=val`, `${!map[@]}`, `unset map[key]` |
| `03_iteration.sh` | All iteration patterns | `for elem in "${arr[@]}"`, `for i in "${!arr[@]}"`, C-style `for ((;;))`, `while` counter |
| `04_mapfile.sh` | Reading into arrays | `mapfile -t arr < file`, `readarray`, here-string input |
| `05_parameter_expansion.sh` | String manipulation | `${var:-default}`, `${#var}`, `${var#pat}`, `${var/pat/repl}`, `${var^^}` |
| `06_here_docs.sh` | Here-documents | `<<EOF`, `<<'EOF'` (literal), `<<-EOF` (tabs), `<<<"str"` (here-string) |

## Common Patterns

```bash
# Iterate safely over array elements (preserves spaces)
for item in "${my_array[@]}"; do
    echo "$item"
done

# Default value for unset variable
local port="${PORT:-8080}"

# Read file into array
mapfile -t lines < "input.txt"

# Trim file extension
filename="data.tar.gz"
basename="${filename%%.*}"   # → "data"
```

## Basado en lo aprendido hasta ahora, creá un script que...

---

#### Desafío 1B — Basado en `01_indexed_arrays.sh`, `04_mapfile.sh`, `05_parameter_expansion.sh`, y `06_here_docs.sh`

Basado en lo que viste en `01_indexed_arrays.sh`, `04_mapfile.sh`, y `05_parameter_expansion.sh`, creá un script que:

1. Use un here-doc (como en `06_here_docs.sh`) para definir datos de ejemplo con formato clave=valor, una por línea.
2. Lea esos datos en un array con `mapfile`.
3. Procese cada línea con parameter expansion para separar clave y valor (`${line%%=*}` y `${line#*=}`).
4. Almacene los pares en un array asociativo (`declare -A`) y luego los imprima como una tabla formateada.

💡 Pista: arrancá copiando `04_mapfile.sh` y reemplazá el contenido del tmpfile por un here-doc inline. Usá `mapfile -t lines << 'EOF'...EOF`. Después, para cada línea: `key="${line%%=*}"` y `val="${line#*=}"`. Creá `declare -A config` y asigná `config["$key"]="$val"`.

---

#### Desafío 2A — Basado en `02_associative_arrays.sh`

Tomá el script `02_associative_arrays.sh` y modificálo para que:

1. En lugar de las frutas/precios fijos, lea entrada del usuario con `read -p` para agregar productos al carrito (nombre del producto y precio).
2. El usuario puede seguir agregando hasta que escriba "listo".
3. Al final, use `${!map[@]}` para iterar las claves y mostrar el ticket con el total calculado con `(( total += map[$item] ))`.

💡 Pista: reemplazá la declaración fija del array por un loop `while true; do read -p "Producto: " prod; [[ "$prod" == "listo" ]] && break; read -p "Precio: " precio; carrito["$prod"]=$precio; done`. Al final, iterá con `for item in "${!carrito[@]}"; do`.
