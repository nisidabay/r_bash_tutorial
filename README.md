# Bash — From Zero to Real Tools

A progressive, code-first curriculum for learning Bash scripting.
No external dependencies — just the shell and real problems.

**14 progressive groups. 86 scripts + 28 exercises. All Bash, all stdlib.**

## Who This Is For

- You write one-liners but want to write real scripts
- You copy-paste from Stack Overflow and want to understand what it does
- You want a language that's already installed on every Linux machine

## Two Paths In

### Path A: The Sampler (~15 min)

Read the concept READMEs. Each group has challenges to practice what you learned.
Pick one that interests you and try it:

```bash
cat 01_basics/concept/README.md           
cat 05_file_io_basics/concept/README.md  
cat 10_terminal_ui/concept/README.md    
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
`07a_case_flow` → `07b_namerefs_data` → `07c_argument_parsing` → `07d_printf_deep_dive` →
`08_file_descriptors` → `09_system_admin` → `10_terminal_ui` → `11_algorithms_data`.

### Exercises

Each group has exercises under `exercises/<group>/` with incomplete scripts
to complete (`exercise_NX.sh`) and solutions to check your work. Run the
verify script to test your solutions:

```bash
bash exercises/01_basics/verify.sh
```

Or run all groups at once:

```bash
bash exercises/verify.sh
```

## The Curriculum (14 Groups)

| # | Group | Concept files | What you learn |
|---|---|---|---|
| 01 | Basics | 6 | Variables, quoting, exit codes, shebangs, echo/printf, IFS |
| 02 | Control Flow | 6 | if/elif/else, test/[[ ]], for/while/until, case, break/continue |
| 03 | Functions | 7 | define/call, arguments, return codes, local, main() pattern, source |
| 04 | Arrays & Strings | 6 | Indexed/associative arrays, iteration, mapfile, parameter expansion, here-docs |
| 05 | File I/O Basics | 8 | read, write, redirection, pipes, here-strings, /dev/stdin, here-string multi-line, function redirect |
| 06 | Processes | 7 | Command substitution, subshells, background jobs, wait, trap, mktemp, process substitution |
| 07 | Advanced Bash | *(split)* | *(split into 07a–07d)* |
| 07a | Case Flow Control | 4 | Templates, `;&`/`;&&`, multi-condition validation |
| 07b | Namerefs & Data | 4 | `local -n`, arrays by ref, stdin-to-associative |
| 07c | Argument Parsing | 3 | getopts standard, long options, regex INI parser |
| 07d | Printf Deep Dive | 3 | Format specifiers, date formatting, alignment, ANSI colors |
| 08 | File Descriptors | 10 | FD read/write, dual output, non-blocking reads, timeouts, parallel download |
| 09 | System Admin | 7 | Desktop entries, services, select menus, stow, traps, error reporting, nullglob, find |
| 10 | Terminal UI | 7 | Progress bars, animations, fzf integration, printf formatting, tput |
| 11 | Algorithms & Data | 7 | ROT13, fake data, linear search, random data, bubble sort, binary search, word frequency |

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
This keeps the learning path progressive — no jumping from "hello world"
to a 200-line system administration script.

## References

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) — static analysis for shell scripts
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
