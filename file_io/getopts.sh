#!/bin/bash

# Practical example of getopts usage

# Function to display help message
display_help() {
    echo "Usage: $0 [-v] -f FILE -n NAME [-h]"
    echo ""
    echo "Mandatory arguments:"
    echo "  -f FILE     Specify input file (required)"
    echo "  -n NAME     Specify a name (required)"
    echo ""
    echo "Optional arguments:"
    echo "  -v          Verbose mode"
    echo "  -h          Display this help message"
}

# Initialize variables
verbose=false
input_file=""
name=""

# Parse options using getopts
while getopts ":vf:n:h" opt; do
    case $opt in
    v)
        verbose=true
        echo "Verbose mode enabled" >&2
        ;;
    f)
        input_file="$OPTARG"
        echo "Input file set to: $input_file" >&2
        ;;
    n)
        name="$OPTARG"
        echo "Name set to: $name" >&2
        ;;
    h)
        display_help
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        display_help
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        display_help
        exit 1
        ;;
    esac
done

# Shift the processed options
shift $((OPTIND - 1))

# Check if there are remaining arguments (non-option arguments)
if [ $# -gt 0 ]; then
    echo "Remaining arguments:" "$@" >&2
fi

# Validate required arguments
if [ -z "$input_file" ] || [ -z "$name" ]; then
    echo "Error: Both -f and -n options are required." >&2
    display_help
    exit 1
fi

# Example usage of parsed options
if [ "$verbose" = true ]; then
    echo "Running in verbose mode."
fi

if [ -n "$input_file" ]; then
    echo "Processing file: $input_file"
fi

if [ -n "$name" ]; then
    echo "Hello, $name!"
fi

echo "Script completed successfully."
