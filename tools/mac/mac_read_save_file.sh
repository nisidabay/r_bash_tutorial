#!/usr/bin/env bash

# Checks if the programs passed as strings are installed
chk_dependencies() {
    local -a dependencies_array=($@)
    local -a missing=()
    for program in "${dependencies_array[@]}"; do
        if ! command -v "$program" >/dev/null; then
            missing+=("$program")
        fi
    done
    if [[ "${#missing[@]}" -gt 0 ]]; then
        local missing_programs="${missing[*]}"
        echo "Install the missing dependencies before continuing: $missing_programs"
        osascript -e "display notification \"Install the following programs before continuing: $missing_programs\" with title \"Missing Dependencies\""
        exit 1
    fi
}

# Unalias cat to bat
unalias cat 2> /dev/null

# Execution starts HERE
chk_dependencies "say" "ffmpeg" "osascript"


# Function to print usage
usage() {
    echo "Usage: $0 [-m] <filename>"
    echo "  -m: Save as MP3 instead of reading aloud"
    exit 1
}

# Parse options
save_mp3=false
while getopts "m" opt; do
    case $opt in
    m) save_mp3=true ;;
    *) usage ;;
    esac
done
shift $((OPTIND - 1))

# Check if a file is provided as an argument
if [ $# -eq 0 ]; then
    usage
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File not found!"
    exit 1
fi

if $save_mp3; then
    # Convert to MP3 using ffmpeg
    output_file="${1%.*}.mp3"
    cat "$1" | say -o temp.aiff && ffmpeg -i temp.aiff -acodec libmp3lame -q:a 2 "$output_file" && rm temp.aiff
    echo "Saved as $output_file"
    osascript -e "display notification \"Saved as $output_file\" with title \"File Conversion\""
else
    # Read the file aloud using 'say' command
    cat "$1" | say
    echo "Finished reading the file."
    osascript -e "display notification \"Finished reading the file.\" with title \"File Reading\""
fi
