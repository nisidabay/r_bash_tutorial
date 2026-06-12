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

## Now Build Your Own

Write a script that launches 5 background jobs (e.g., `sleep` with different durations), captures their PIDs, uses `wait -n` to report each completion as it happens, and cleans up any temp files with a `trap` on `EXIT`.
