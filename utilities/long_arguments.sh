#!/usr/bin/env BASH
#
# getopts tweak to parse long arguments

PROGRAM=${0##*/}
VERSION="$PROGRAM 0.0.0"

VERBOSE=":"
DEBUG=":"

display_help() {
    cat <<-EOF

This script does nothing but show help; a real script should be more exciting.

usage: $PROGRAM (options)

Options:
-a | --amode   = Enable "amode", default is off
-d | --debug   = Include debug output, default is off
-h | --help    = Show this help message and exit
-o | --outfile = Send output to file instead of STDOUT
-v | --verbose = Include verbose output, default is off
-V | --version = Show the version and exit

EOF
}
main() {
    while getopts ":-:adho:vV" VAL; do
        case $VAL in
        a) AMODE=1 ;;
        d) DEBUG="echo" ;;
        h)
            display_help
            exit 1
            ;;
        o) OFILE="$OPTARG" ;;
        v) VERBOSE="echo" ;;
        V) echo "$VERSION" && exit 0 ;;

        -)
            case $OPTARG in
            amode) AMODE=1 ;;
            debug) DEBUG="echo" ;;
            help)
                display_help
                exit 1
                ;;
            outfile=*) OFILE="${OPTARG#*=}" ;;
            outfile)
                OFILE="${!OPTIND}"
                OPTIND++
                ;;
            verbose) VERBOSE="echo" ;;
            version)
                echo "$VERSION"
                exit 0
                ;;
            *)
                echo "unknown long argument: $OPTARG"
                exit
                ;;
            esac
            ;;

        :)
            echo "error: no argument supplied"
            ;;
        *)
            echo "error: unknown option $OPTARG"
            echo "valid options are: aov"
            ;;
        esac
    done
    shift $((OPTIND - 1))
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
