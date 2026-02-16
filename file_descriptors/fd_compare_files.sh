#!/usr/bin/env bash
set -euo pipefail

# --- Error Handling ---
handle_error() {
    local error_code=$?
    local line=$1
    echo "ERROR on line $line (exit code: $error_code)" >&2
    exit 1
}
trap 'handle_error $LINENO' ERR

# --- Main Function ---
main() {
    # 1. Setup Files (Same as before)
    if [[ "$#" -eq 0 ]]; then
        echo "No arguments provided. Using temporary example files..."
        file_1=$(mktemp)
        file_2=$(mktemp)
        trap 'rm -f "${file_1}" "${file_2}"' EXIT

        cat >"${file_1}" <<EOF
Hola Pepe
This is a new paragraph. 
EOF

        cat >"${file_2}" <<EOF
Hola Carlos
This is another paragraph. 
EOF
    elif [[ "$#" -eq 2 ]]; then
        file_1="$1"
        file_2="$2"
        if [[ ! -f "$file_1" ]] || [[ ! -f "$file_2" ]]; then
            echo "Error: One or both files do not exist."
            exit 1
        fi
    else
        echo "Usage: $0 [file1 file2]"
        exit 1
    fi

    # 2. Open File Descriptors
    exec 3<"${file_1}"
    exec 4<"${file_2}"

    local line1
    local line2
    local eof1=0
    local eof2=0

    # 3. The Correct Loop Logic
    while true; do
        # Try to read from file 1. If it fails (End of File), set flag eof1 to 1.
        # We explicitly return 'true' (|| true) so the script doesn't crash on EOF due to set -e
        IFS= read -r line1 <&3 || eof1=1

        # Try to read from file 2. If it fails, set flag eof2 to 1.
        IFS= read -r line2 <&4 || eof2=1

        # ONLY stop if BOTH files have reached the end
        if [[ $eof1 -eq 1 ]] && [[ $eof2 -eq 1 ]]; then
            break
        fi

        # Compare lines
        if [[ "${line1}" != "${line2}" ]]; then
            echo "DIFF: '${line1}' vs '${line2}'"
        fi
    done

    # 4. Cleanup
    exec 3<&-
    exec 4<&-
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
