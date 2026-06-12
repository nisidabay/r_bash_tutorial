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

## Now Build Your Own

Write a script that reads a CSV file into an array with `mapfile`, then uses parameter expansion to strip quotes from each field, and prints the result as a formatted table.
