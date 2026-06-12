#!/usr/bin/env bash
#
# Wrapper script for Create Audio gTTS
# This script activates the virtual environment and runs the text-to-speech tool

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# If this script is in ~/bin, the actual project is in ~/bin/create_audio_gtts
if [[ "$SCRIPT_DIR" == */bin && "$SCRIPT_DIR" != */create_audio_gtts ]]; then
    PROJECT_DIR="$SCRIPT_DIR/create_audio_gtts"
else
    PROJECT_DIR="$SCRIPT_DIR"
fi

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Create Audio gTTS project directory not found at $PROJECT_DIR"
    echo "Please ensure the project is installed in ~/bin/create_audio_gtts/"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "$PROJECT_DIR/venv" ]; then
    echo "Error: Virtual environment not found in $PROJECT_DIR"
    echo "Please run setup.sh first:"
    echo "  cd $PROJECT_DIR && ./setup.sh"
    exit 1
fi

# Save the current working directory (where user ran the command)
ORIGINAL_DIR="$(pwd)"

# Change to project directory
cd "$PROJECT_DIR"

# Activate virtual environment
source venv/bin/activate

# Check if create_audio.py exists
if [ ! -f "create_audio.py" ]; then
    echo "Error: create_audio.py not found in $PROJECT_DIR"
    exit 1
fi

# If user forgot the 'text' subcommand and first arg looks like text, auto-add it
if [[ $# -gt 0 && "$1" != "text" && "$1" != "test" && "$1" != "--help" && "$1" != "--version" ]]; then
    echo "Auto-adding 'text' subcommand..."
    set -- "text" "$@"
fi

# If output file is specified with -o, make it relative to original directory
args=()
output_to_original=false
for ((i=1; i<=$#; i++)); do
    arg="${!i}"
    if [[ "$arg" == "-o" || "$arg" == "--output-file" ]]; then
        # Next argument is the output file
        next_i=$((i+1))
        if [[ $next_i -le $# ]]; then
            output_file="${!next_i}"
            # If it's not an absolute path, make it relative to original directory
            if [[ "$output_file" != /* ]]; then
                output_file="$ORIGINAL_DIR/$output_file"
                set -- "${@:1:$i}" "$output_file" "${@:$((next_i+1))}"
            fi
        fi
    fi
done

# Run the text-to-speech tool with all passed arguments
python create_audio.py "$@"

# Deactivate virtual environment
deactivate