# 08 File Descriptors — Read, Write, Compare, Timeout, and Parallel I/O

## Quick Start

```bash
bash 08_file_descriptors/concept/01_fd_read.sh
bash 08_file_descriptors/concept/02_fd_write.sh
bash 08_file_descriptors/concept/04_fd_nonblocking.sh
bash 08_file_descriptors/concept/09_parallel_download.sh
bash 08_file_descriptors/concept/13_process_substitution.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_fd_read.sh` | Reading from a file descriptor | `exec 3<"$input_file"`, `read -r line <&3`, `exec 3<&-` |
| `02_fd_write.sh` | Writing via a file descriptor | `exec 3>>"$LOG_FILE"`, `echo "msg" >&3`, `exec 3>&-` |
| `03_fd_compare.sh` | Line-by-line file comparison with two FDs | `exec 3<"file1"` + `exec 4<"file2"`, dual-read loop, EOF handling |
| `04_fd_nonblocking.sh` | Non-blocking read with timeout | `read -r -t $TIMEOUT line <&3`, process substitution with delay |
| `05_fd_logging.sh` | Logging to a file via FD | `exec 3>>"$LOG_FILE"`, `log_message()` wrapper, error handler flushes |
| `06_fd_dual_output.sh` | Log to file AND console simultaneously | `tee -a /dev/fd/3`, append-mode FD + stdout mirror |
| `07_fd_timeout.sh` | Per-line timeout on stream reads | `while read -r -t 3 line <&3`, graceful loop termination on timeout |
| `08_universal_input.sh` | Universal input: file arg or pipe | `< "${input_filename:-/dev/stdin}"`, `[[ -t 0 ]]` terminal check |
| `09_parallel_download.sh` | Parallel download with FIFOs | `mkfifo`, `curl --range`, `dd seek=... conv=notrunc`, `wait` for PIDs |
| `10_here_string_read.sh` | Multi-line string with here-string | `<<<"$content"`, `IFS= read -r` inside a `while` loop |
| `11_dual_file_read.sh` | Side-by-side file reading + `diff` | Simultaneous FD read, `diff -u --color=always` |
| `12_function_redirect.sh` | Entire function output redirection | `func() { ... } >> "$LOG_FILE" 2>&1`, wrapper logging pattern |
| `13_process_substitution.sh` | Process substitution basics | `<(...)` as a file argument, avoids subshell |

## Common Patterns

```bash
# Open a file descriptor for reading
exec 3<"$filename"
while IFS= read -r line <&3; do
    echo "Got: $line"
done
exec 3<&-

# Open a file descriptor for appending
exec 3>>"$logfile"
echo "$(date): message" >&3
exec 3>&-

# Non-blocking read from a background process
exec 3< <(sleep 2 && echo "data")
if read -r -t 5 line <&3; then
    echo "Received: $line"
fi
exec 3<&-

# Universal input (file argument or pipe)
while IFS= read -r line; do
    process "$line"
done < "${filename:-/dev/stdin}"

# Dual output — file and console
log_message() {
    echo "[$(date)] $*" | tee -a /dev/fd/3
}
exec 3>>"$LOG_FILE"
log_message "Script started"
exec 3>&-

# Function-level output redirection
log_operation() {
    "$@"
} >> "$LOG_FILE" 2>&1
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `03_fd_compare.sh`

Tomá el script `03_fd_compare.sh` y modificálo para que:

1. En lugar de comparar archivos temporales, tomá dos archivos como argumentos del script (`$1` y `$2`).
2. Si no se pasan dos argumentos, mostrá un mensaje de uso y salí con código 1.
3. Agregá un contador de diferencias: al final, reportá "X líneas diferentes encontradas".

💡 Pista: reemplazá la creación de archivos temporales (líneas 46-58) por `file_1="$1"` y `file_2="$2"`. Agregá `[[ $# -eq 2 ]] || { echo "Uso: ..."; exit 1; }`. En el loop de comparación, agregá `((diff_count++))` cuando las líneas difieran.

---

#### Desafío 2A — Basado en `05_fd_logging.sh` y `06_fd_dual_output.sh`

Tomá el script `05_fd_logging.sh` y modificálo para que:

1. En lugar de solo loggear a un archivo por FD, usá el patrón de `06_fd_dual_output.sh` para que los mensajes vayan también a la consola.
2. Agregá un nivel de log: `log_info()`, `log_warn()`, `log_error()` — cada uno con un prefijo diferente (`[INFO]`, `[WARN]`, `[ERROR]`).
3. El `log_error()` debe escribir a stderr además del log y la consola.

💡 Pista: copiá la función `log_message` de `06_fd_dual_output.sh` (línea 45-51) que usa `tee -a /dev/fd/3`. Creá tres wrappers: `log_info() { log_message "[INFO] $*"; }`, `log_warn() { log_message "[WARN] $*"; }`, y `log_error() { log_message "[ERROR] $*" >&2; }`.

---

#### Desafío 3A — Basado en `07_fd_timeout.sh`

Tomá el script `07_fd_timeout.sh` y modificálo para que:

1. En lugar de leer de un archivo fijo, leé de un proceso en background que genere una línea cada N segundos (por ejemplo, `(for i in {1..5}; do echo "línea $i"; sleep $((RANDOM % 4 + 1)); done)`).
2. Usá `exec 3< <(...)` con ese proceso como fuente.
3. Si el `read -t` expira (el proceso tarda más de 3 segundos), mostrá un mensaje "Timeout — línea lenta" y continuá con la siguiente.

💡 Pista: reemplazá el `cat` de la línea 43-48 por un proceso en background: `exec 3< <(for i in {1..5}; do echo "línea $i"; sleep $((RANDOM % 4 + 1)); done)`. En el while, usá `if read -r -t 3 line <&3; then echo "Leído: $line"; else echo "Timeout"; fi`.