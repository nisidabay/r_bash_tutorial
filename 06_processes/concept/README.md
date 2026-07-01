# 06 Processes — Subshells, Jobs, Signals, Temp Files

## Quick Start

```bash
bash 06_processes/concept/01_command_substitution.sh
bash 06_processes/concept/02_subshells.sh
bash 06_processes/concept/03_background_jobs.sh
bash 06_processes/concept/04_wait.sh
bash 06_processes/concept/05_trap_basics.sh
bash 06_processes/concept/06_mktemp.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_command_substitution.sh` | Capturing command output | `$(command)`, backticks, nesting, in-string substitution |
| `02_subshells.sh` | Subshell isolation | `( ... )` isolated env, `cd` doesn't leak, `{ }` no subshell |
| `03_background_jobs.sh` | Background execution | `&`, `$!`, `jobs`, `fg`/`bg`, `disown`, `nohup` |
| `04_wait.sh` | Waiting for children | `wait`, `wait $pid`, `wait -n`, parallel execution pattern |
| `05_trap_basics.sh` | Signal handling | `trap 'cmd' EXIT`, `trap 'cmd' SIGINT`, `trap -p` |
| `06_mktemp.sh` | Secure temp files | `mktemp`, `mktemp -d`, `mktemp -t`, `trap cleanup EXIT` |

## Common Patterns

```bash
# Parallel execution with wait
for url in "${urls[@]}"; do
    curl -s "$url" &
done
wait
echo "All downloads complete"

# Safe temp file with auto-cleanup
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Subshell for isolated changes
(cd /some/dir && do_something)  # parent's cwd unchanged

# Capture PID of background job
long_running_task &
pid=$!
# ... do other work ...
wait "$pid"
```

## Basado en lo aprendido hasta ahora, creá un script que...

---

#### Desafío 1B — Basado en `03_background_jobs.sh`, `04_wait.sh`, `05_trap_basics.sh`, y `06_mktemp.sh`

Basado en lo que viste en `03_background_jobs.sh`, `04_wait.sh`, y `06_mktemp.sh`, creá un script que:

1. Cree un directorio temporal con `mktemp -d` (como en `06_mktemp.sh`).
2. Lance 3 procesos en background que escriban un archivo cada uno dentro de ese directorio temporal, cada uno con una demora diferente (simulada con `sleep`).
3. Capture los PIDs con `$!` y espere a que terminen con `wait $pid` (como en `03_background_jobs.sh` y `04_wait.sh`).
4. Use `trap` en EXIT para limpiar el directorio temporal automáticamente.

💡 Pista: copiá el patrón de `06_mktemp.sh` para el `TMPDIR`, `trap cleanup EXIT` y `cleanup()`. Después, para cada job: `(sleep $((RANDOM % 5)); echo "dato" > "$TMPDIR/archivo_$i.txt") &` con `pids+=($!)`. Al final, `for pid in "${pids[@]}"; do wait "$pid"; done`.

---

#### Desafío 2A — Basado en `01_command_substitution.sh`

Tomá el script `01_command_substitution.sh` y modificálo para que:

1. En lugar de mostrar solo la fecha y usuarios, mostrá también: cantidad de procesos del sistema (`ps -e | wc -l`), uso de memoria libre (`free -m | awk 'NR==2{print $7}'`), y el hostname en mayúsculas.
2. Cada valor debe capturarse con `$(...)` y almacenarse en variables separadas.
3. Mostrá todo como un reporte formateado con `printf`.

💡 Pista: agregá líneas como `procesos=$(ps -e --no-headers | wc -l)` y `mem_libre=$(free -m | awk 'NR==2{print $7}')`. Después usá `printf` como en `05_echo_printf.sh` para mostrar: "Procesos: %d | Memoria libre: %d MB".
