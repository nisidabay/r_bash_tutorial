# 05 File I/O Basics — Read, Write, Redirect, Pipe

## Quick Start

```bash
bash 05_file_io_basics/concept/01_read_input.sh
bash 05_file_io_basics/concept/02_write_output.sh
bash 05_file_io_basics/concept/03_redirect_basics.sh
bash 05_file_io_basics/concept/04_pipes.sh
bash 05_file_io_basics/concept/05_here_strings.sh
bash 05_file_io_basics/concept/06_dev_stdin.sh
bash 05_file_io_basics/concept/07_here_string_read.sh
bash 05_file_io_basics/concept/08_function_redirect.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_read_input.sh` | Reading user input | `read -p`, `read -r`, `read -a`, `read -t`, `read -s` |
| `02_write_output.sh` | Writing output | `echo` vs `printf`, `>` overwrite, `>>` append, `tee`, `/dev/null` |
| `03_redirect_basics.sh` | File descriptor redirection | `>`, `2>`, `&>`, `2>&1`, order sensitivity |
| `04_pipes.sh` | Pipes and pipelines | `\|` chaining, `tee` in pipelines, `PIPESTATUS` array |
| `05_here_strings.sh` | Here-strings | `<<<"str"`, feeding variables, `while read` without subshell |
| `06_dev_stdin.sh` | /dev/stdin tricks | `${1:-/dev/stdin}`, `[[ -p /dev/stdin ]]`, file-or-stdin pattern |
| `07_here_string_read.sh` | Multi-line string processing with `<<<` | `<<<"$content"` with `while read`, here-doc vs here-string |
| `08_function_redirect.sh` | Function output redirection | `func() { ... } >> "$LOG_FILE" 2>&1`, wrapper logging pattern |

## Common Patterns

```bash
# Read input with timeout
if read -r -t 5 -p "Quick response: "; then
    echo "Got: $REPLY"
fi

# Redirect both stdout and stderr to a file
command &> output.log

# Check exit codes in a pipeline
command1 | command2
echo "Exit codes: ${PIPESTATUS[@]}"

# Accept file argument or stdin
input="${1:-/dev/stdin}"
while IFS= read -r line; do
    echo "$line"
done < "$input"
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `04_pipes.sh`

Tomá el script `04_pipes.sh` y modificálo para que:

1. En lugar de los comandos fijos, leé una lista de palabras desde un archivo (usando `mapfile` como viste en el grupo 04).
2. Pasá cada palabra por un pipeline: `echo "$palabra" | rev | tr 'a-z' 'A-Z'` para invertirla y ponerla en mayúsculas.
3. Usá `PIPESTATUS` para verificar que cada etapa del pipeline funcionó, y mostrá un error si alguna falló.

💡 Pista: arrancá con `mapfile -t words < palabras.txt` (creá el archivo primero). Después, para cada word: `result=$(echo "$word" | rev | tr 'a-z' 'A-Z')` y chequeá `echo "${PIPESTATUS[@]}"` después del pipeline. Si algún valor no es 0, reportá el error.

---

#### Desafío 2B — Basado en `01_read_input.sh`, `02_write_output.sh`, y `06_dev_stdin.sh`

Basado en lo que viste en `01_read_input.sh` y `06_dev_stdin.sh`, creá un script que:

1. Acepte un archivo como argumento O lea de stdin (patrón `${1:-/dev/stdin}` de `06_dev_stdin.sh`).
2. Use `read -p` para preguntar al usuario un prefijo de línea.
3. Lea cada línea de la entrada y la escriba en un archivo de salida (`salida_$(date +%s).txt`) con el prefijo agregado al inicio, usando `>>` para append.
4. Informe cuántas líneas procesó.

💡 Pista: copiá la estructura de `06_dev_stdin.sh` — usá `local input="${1:-/dev/stdin}"`. Después de leer el prefijo con `read -p "Prefijo: " prefijo`, usá `while IFS= read -r line; do echo "$prefijo$line" >> "$outfile"; done < "$input"`. Contá con un contador `((count++))`.
