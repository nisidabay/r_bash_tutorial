# 05 File I/O Basics — Read, Write, Redirect, Pipe

## Quick Start

```bash
bash 05_file_io_basics/concept/01_read_input.sh
bash 05_file_io_basics/concept/02_write_output.sh
bash 05_file_io_basics/concept/03_redirect_basics.sh
bash 05_file_io_basics/concept/04_pipes.sh
bash 05_file_io_basics/concept/05_here_strings.sh
bash 05_file_io_basics/concept/06_dev_stdin.sh
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

## Now Build Your Own

Write a script that reads a list of URLs from a file (or stdin), uses `curl` to fetch each one, logs both stdout and stderr to separate files with `tee`, and reports the exit status of each download.
