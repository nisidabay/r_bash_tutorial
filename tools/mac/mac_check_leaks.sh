#!/usr/bin/env bash
#
# Check for memory leaks and profile performance on Mac
# This is for C executable files

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

help() {
    echo "Usage: $(basename $0) <C executable file> [args...]"
    echo "This script checks for memory leaks and profiles performance of a C executable."
    exit 1
}

# Execution starts HERE
chk_dependencies "leaks"


# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No argument provided."
    help
fi

# The first argument is the executable
executable="$1"

# Check if the provided argument is an executable file
if [ ! -x "$executable" ]; then
    echo "Error: '$executable' is not an executable file."
    help
fi

# Shift the arguments to pass any remaining ones to the executable
shift

echo "Profiling and checking for memory leaks in $executable..."
echo "IF THE EXECUTABLE IS INTERACTIVE, START TYPING. End execution with CTRL-D"

# Use 'time' for basic performance profiling and 'leaks' for memory leak detection
# The '3>&1 1>&2 2>&3' part is used to capture stderr of 'time' command
{ time leaks --atExit -- "$executable" "$@"; } 3>&1 1>&2 2>&3 | tee performance.txt

leak_status=${PIPESTATUS[0]}

# Check the exit status of the leaks command
if [ $leak_status -eq 0 ]; then
    echo "Memory leak check completed successfully."
    echo "No leaks detected."
    osascript -e 'display notification "No leaks detected." with title "Memory Leak Check"'
elif [ $leak_status -eq 1 ]; then
    echo "Memory leak check completed. Leaks were detected."
    osascript -e 'display notification "Leaks were detected." with title "Memory Leak Check"'
else
    echo "Error occurred during memory leak check."
    osascript -e 'display notification "Error during leak check." with title "Memory Leak Check"'
fi

echo "Performance metrics have been saved to performance.txt"
echo "Summary of performance metrics:"
cat performance.txt
