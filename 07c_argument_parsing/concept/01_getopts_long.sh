#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Advanced Argument Parsing with `getopts` for Long and Short Options
#
# This script demonstrates a common and powerful technique to make `getopts`,
# which natively only supports short options (e.g., `-v`), also handle long
# options (e.g., `--verbose`).
#
# How it Works:
# 1. The `getopts` string starts with a colon (`:`) to enable silent error
#    handling, allowing the script to manage errors manually.
# 2. A hyphen (`-`) is included in the options string (`":-:adho:vV"`). This
#    tells `getopts` to treat long options (which start with `--`, but are seen
#    by `getopts` as a single argument starting with `-`) as a special case.
# 3. When `getopts` encounters an argument starting with `-` that is not a
#    defined short option (like `--verbose`), it matches the special `-` case.
#    - `VAL` is set to `-`.
#    - `OPTARG` is set to the full long option name (e.g., `verbose`).
# 4. A nested `case` statement inside the `case $VAL in -)` block then handles
#    the specific long option stored in `OPTARG`.
#
# This approach provides a robust way to handle both `-o file` and `--outfile=file`.
# ==============================================================================

# --- Configuration ---
readonly PROGRAM="${0##*/}"
readonly VERSION="$PROGRAM 1.0.0"

# --- Functions ---
display_help() {
    cat <<-EOF
This is a template for a script that accepts both short and long command-line options.

Usage: $PROGRAM [options] [arguments]

Options:
  -a, --amode         Enable "amode" (example flag). Default: off.
  -d, --debug         Enable debug output. Default: off.
  -h, --help          Show this help message and exit.
  -o, --outfile <file> Send output to a file instead of STDOUT.
  -v, --verbose       Enable verbose output. Default: off.
  -V, --version       Show the script version and exit.

EOF
}

# --- Main Logic ---
main() {
    # Initialize variables with default values.
    local AMODE=0
    local DEBUG=false
    local OFILE=""
    local VERBOSE=false

    # The `getopts` loop.
    while getopts ":-:adho:vV" VAL; do
        # `VAL` holds the option character (e.g., 'v')
        # `OPTARG` holds the argument for options that require one (e.g., the filename for '-o')
        case $VAL in
            # --- Short Options ---
            a) AMODE=1 ;;
            d) DEBUG=true ;;
            h) display_help; exit 0 ;;
            o) OFILE="$OPTARG" ;;
            v) VERBOSE=true ;;
            V) echo "$VERSION"; exit 0 ;;

            # --- Long Option Handling ---
            -)
                case "$OPTARG" in
                    amode) AMODE=1 ;;
                    debug) DEBUG=true ;;
                    help) display_help; exit 0 ;;
                    version) echo "$VERSION"; exit 0 ;;
                    verbose) VERBOSE=true ;;

                    # Long option with an argument (e.g., --outfile=file.txt)
                    outfile=*)
                        OFILE="${OPTARG#*=}"
                        ;;
                    # Long option with a space-separated argument (e.g., --outfile file.txt)
                    # This case requires manually advancing OPTIND.
                    outfile)
                        # Check if the next argument exists.
                        if [[ -n "${!OPTIND:-}" ]]; then
                            OFILE="${!OPTIND}"
                            OPTIND=$((OPTIND + 1))
                        else
                            echo "Error: --$OPTARG requires a file argument." >&2
                            exit 1
                        fi
                        ;;

                    *)
                        echo "Error: Unknown long option --$OPTARG" >&2
                        display_help
                        exit 1
                        ;;
                esac
                ;;

            # --- Error Handling ---
            # Handles missing arguments for options that require them (e.g., -o)
            :)
                echo "Error: Option '-$OPTARG' requires an argument." >&2
                exit 1
                ;;
            # Handles unknown short options
            \?)
                echo "Error: Unknown option '-$OPTARG'" >&2
                display_help
                exit 1
                ;;
        esac
    done
    # Remove all processed options from the argument list.
    shift $((OPTIND - 1))

    # --- Post-parsing Logic ---
    # At this point, "$@" contains only the remaining non-option arguments.
    echo "--- Parsed Options ---"
    echo "AMODE: $AMODE"
    echo "DEBUG: $DEBUG"
    echo "VERBOSE: $VERBOSE"
    echo "Output File: ${OFILE:-"STDOUT"}"
    echo "Remaining arguments: $*"
    echo "----------------------"

    # A real script would do something with the options and arguments here.
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
