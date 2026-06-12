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

## Now Build Your Own

Write a script that reads from two files simultaneously (one per FD), merges their lines alternatingly, logs progress to a third FD (a log file), and displays a status message both on screen and in the log. Add a 5-second timeout for slow input.