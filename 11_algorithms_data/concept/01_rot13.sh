#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# ROT13 Encryption/Decryption Utility
#
# This script applies the simple ROT13 substitution cipher to a file. ROT13 is
# not a form of secure encryption; it is a toy cipher that replaces a letter
# with the letter 13 places after it in the alphabet. Applying it twice
# restores the original text.
#
# Usage:
#   ./rot.sh -e <filename>   # Encrypts the file, creating <filename>.enc
#   ./rot.sh -d <filename.enc> # Decrypts the file, creating <filename>
#
# The script includes user prompts for overwriting files and deleting originals
# to prevent accidental data loss.
# ==============================================================================

# --- Helper Functions ---

# Displays the usage message and exits.
usage() {
    cat <<EOF
Usage: ${0##*/} -e|-d <filename>
  -e : Encrypt (Apply ROT13), creates <filename>.enc
  -d : Decrypt (Apply ROT13), restores <filename> from <filename.enc>
EOF
    exit 1
}

# Asks the user for confirmation before removing the original file after encryption.
remove_original() {
    local original_file="$1"
    # A more standard confirmation loop:
    # while true; do
    #     read -rp "Remove '$original_file' (y/n)? " yn
    #     case $yn in
    #         [Yy]*) rm "$original_file"; break ;;
    #         [Nn]*) echo "Original file kept."; break ;;
    #         *) echo "Please answer yes or no." ;;
    #     esac
    # done
    read -rp "Remove '$original_file' (Y/n)? " prompt
    # Default to 'Y' if the user just presses Enter.
    if [[ "$prompt" =~ ^[yY]?$ ]]; then
        echo "Removing '$original_file'..."
        rm "$original_file"
    else
        echo "Original file kept."
    fi
}

# Determines the output filename based on the mode (encrypt/decrypt).
get_output_filename() {
    local mode="$1"
    local input_file="$2"

    if [[ "$mode" == "-e" ]]; then
        echo "${input_file}.enc"
    elif [[ "$mode" == "-d" ]]; then
        if [[ "$input_file" != *.enc ]]; then
            echo "Error: For decryption, the input filename must end with .enc" >&2
            exit 1
        fi
        # Use parameter expansion to remove the '.enc' suffix.
        echo "${input_file%.enc}"
    fi
}

# Checks if a file exists and asks for permission to overwrite it.
check_overwrite() {
    local target_file="$1"

    if [[ -e "$target_file" ]]; then
        read -rp "Warning: '$target_file' already exists. Overwrite (Y/n)? " prompt
        if [[ ! "$prompt" =~ ^[yY]?$ ]]; then
            echo "Aborted by user."
            exit 1
        fi
    fi
}

# Performs the actual ROT13 text transformation using the `tr` command.
perform_rot13() {
    local input_file="$1"
    local output_file="$2"

    # `tr` translates characters. The first set 'A-Za-z' is mapped to the
    # second set 'N-ZA-Mn-za-m'. 'A' becomes 'N', 'B' becomes 'O', ...,
    # 'M' becomes 'Z', then 'N' becomes 'A', etc.
    tr 'A-Za-z' 'N-ZA-Mn-za-m' <"$input_file" >"$output_file"
}

# --- Main Execution ---
main() {
    # Validate that exactly two arguments were provided.
    if [[ "$#" -ne 2 ]]; then
        usage
    fi

    local mode="$1"
    local input_file="$2"

    # Validate the mode argument.
    if [[ "$mode" != "-e" && "$mode" != "-d" ]]; then
        echo "Error: Invalid mode '$mode'. Must be -e or -d." >&2
        usage
    fi

    # Validate that the input file exists and is a regular file.
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File '$input_file' not found." >&2
        exit 1
    fi

    # Determine the output filename.
    local output_file
    output_file=$(get_output_filename "$mode" "$input_file")

    # Check for overwrite safety.
    check_overwrite "$output_file"

    # Execute the transformation.
    echo "Processing '$input_file' -> '$output_file'..."
    perform_rot13 "$input_file" "$output_file"

    # If encrypting, offer to remove the original file.
    if [[ "$mode" == "-e" ]]; then
        remove_original "$input_file"
    fi

    echo "Done."
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
