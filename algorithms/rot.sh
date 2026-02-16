#!/usr/bin/env BASH
#
# Rot13 encryption/decryption utility

set -e

usage() {
    cat <<EOF
Usage: $0 -e|-d <filename>
       -e : Encrypt (Apply ROT13), creates <filename>.enc
       -d : Decrypt (Apply ROT13), restores <filename>
EOF
    exit 1
}

# Ask to remove the original file
remove_original() {
    local original_file="$1"
    if [ -e "$original_file" ]; then
        read -rp "Remove '$original_file' (Y/n)? " prompt
        if [[ ! "$prompt" =~ ^["yY"]*$ ]]; then
            echo "Aborted by user."
            exit 1
        fi
        rm "$original_file"
    fi

}
# Determine the new filename based on mode
get_output_filename() {
    local mode="$1"
    local input_file="$2"

    if [[ "$mode" == "-e" ]]; then
        echo "${input_file}.enc"
    elif [[ "$mode" == "-d" ]]; then
        if [[ "$input_file" != *.enc ]]; then
            echo "Error: For decryption, filename must end with .enc" >&2
            exit 1
        fi
        echo "${input_file%.enc}"
    fi
}

# Check if file exists and ask permission
check_overwrite() {
    local target_file="$1"

    if [ -e "$target_file" ]; then
        read -rp "Warning: '$target_file' already exists. Overwrite (Y/n)? " prompt
        if [[ ! "$prompt" =~ ^["yY"]*$ ]]; then
            echo "Aborted by user."
            exit 1
        fi
    fi
}

# Text transformation
perform_rot13() {
    local input="$1"
    local output="$2"

    tr 'A-Za-z' 'N-ZA-Mn-za-m' <"$input" >"$output"
}

main() {
    # Validate Arguments
    [ "$#" -ne 2 ] && usage

    local mode="$1"
    local input_file="$2"

    # Validate Input File
    if [ ! -f "$input_file" ]; then
        echo "Error: File '$input_file' not found."
        exit 1
    fi

    # Calculate Output Filename
    local output_file
    output_file=$(get_output_filename "$mode" "$input_file")

    # Check for safety
    check_overwrite "$output_file"

    # Execute
    echo "Processing '$input_file' -> '$output_file'..."
    perform_rot13 "$input_file" "$output_file"

    if [[ "$mode" =~ "-e" ]]; then
        remove_original "$input_file"
    fi

    echo "Done."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
