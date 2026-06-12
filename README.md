# Bash — From Zero to Real Tools

A progressive, code-first curriculum for learning Bash scripting.
No external dependencies — just the shell and real problems.

**11 groups. 70+ scripts. All Bash, all stdlib.**

## Who This Is For

- You write one-liners but want to write real scripts
- You copy-paste from Stack Overflow and want to understand what it does
- You want a language that's already installed on every Linux machine

## Two Paths In

### Path A: The Sampler (~15 min)

Read the concept READMEs. Each group has a **Now Build Your Own** challenge.
Pick one that interests you and build it:

```bash
cat 01_basics/concept/README.md     # → "Write a greeting script"
cat 05_file_io_basics/concept/README.md  # → "Write a log parser"
cat 10_terminal_ui/concept/README.md    # → "Write a progress bar"
```

### Path B: Systematic (~several weeks)

Work through the numbered groups in order. Each has:

- **concept/README.md** — quick-start table + learning path
- **concept/*.sh** — one concept per file, code-first, runnable standalone

```bash
cd 01_basics/concept
cat README.md                   # see the map
bash 01_hello_variables.sh      # first concept
```

Then keep going: `01_basics` → `02_control_flow` → `03_functions` →
`04_arrays_strings` → `05_file_io_basics` → `06_processes` →
`07_advanced_bash` → `08_file_descriptors` → `09_system_admin` →
`10_terminal_ui` → `11_algorithms_data`.

## The Curriculum (11 Groups)

| # | Group | Concept files | What you learn |
|---|---|---|---|
| 01 | Basics | 6 | Variables, quoting, exit codes, shebangs, echo/printf, IFS |
| 02 | Control Flow | 6 | if/elif/else, test/[[ ]], for/while/until, case, break/continue |
| 03 | Functions | 6 | define/call, arguments, return codes, local, main() pattern, source |
| 04 | Arrays & Strings | 6 | Indexed/associative arrays, iteration, mapfile, parameter expansion, here-docs |
| 05 | File I/O Basics | 6 | read, write, redirection, pipes, here-strings, /dev/stdin |
| 06 | Processes | 6 | Command substitution, subshells, background jobs, wait, trap, mktemp |
| 07 | Advanced Bash | 11 | Namerefs, case flow control, getopts long options, templates, regex parsing |
| 08 | File Descriptors | 13 | FD read/write, dual output, non-blocking reads, timeouts, parallel download |
| 09 | System Admin | 9 | Desktop entries, services, select menus, stow, traps, temp files, diff |
| 10 | Terminal UI | 7 | Progress bars, animations, fzf integration, printf formatting, tput |
| 11 | Algorithms & Data | 4 | ROT13, fake data, linear search, random data generation |

## The Toolbox

`tools/` contains **practical CLI utilities** built with these concepts —
application launchers (rofi/wofi), macOS helpers, system installers, and more.
Everything here was built to solve an actual problem on a Linux machine.

| Directory | Scripts | What it does |
|---|---|---|
| `tools/rofi/` | 28 | Rofi-based launchers, note viewers, keybinding displays |
| `tools/wofi/` | 22 | Wayland-native wofi equivalents |
| `tools/mac/` | 10 | macOS-specific utilities (wifi, USB, venv, etc.) |
| `tools/` (root) | 5 | Installers, TUI tools, test suites |

## Running a Script

```bash
# Every script is standalone — just run it
bash 01_basics/concept/01_hello_variables.sh

# Or make it executable and run directly
chmod +x 01_basics/concept/01_hello_variables.sh
./01_basics/concept/01_hello_variables.sh
```

## Design Principle

Each group's scripts only use concepts from that group and prior groups.
Advanced tools that use concepts from multiple groups live in `tools/`.
This keeps the learning path progressive — no jumping from "hello world"
to a 200-line system administration script.

## References

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) — static analysis for shell scripts
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)