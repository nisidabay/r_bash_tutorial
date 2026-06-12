#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Linear Search Algorithm in Bash
#
# This script demonstrates a simple implementation of the linear search
# algorithm. Linear search is a basic method for finding a target value within
# an array. It sequentially checks each element of the array until a match is
# found or the whole array has been searched.
#
# The function `linear_search` is designed to be reusable and follows standard
# shell practices.
# ==============================================================================

# --- Functions ---

# Performs a linear search on an array.
#
# Arguments:
#   $1: The value to search for.
#   $@: The remaining arguments, which constitute the array to be searched.
#
# Output:
#   - If the value is found, it prints the 0-based index of the first occurrence.
#   - If the value is not found, it prints -1.
#
# Returns:
#   - 0 on success (regardless of whether the item was found or not).
#   - 1 if arguments are incorrect.
linear_search() {
    if (($# < 2)); then
        echo "Usage: linear_search <value_to_find> <array_element_1> [array_element_2] ..." >&2
        return 1
    fi

    local value_to_find="$1"
    shift # Remove the search value from the arguments list.
    local -a array_to_search=("$@")

    local index=-1 # Default to -1 (not found).

    # Iterate through the array with an index.
    for i in "${!array_to_search[@]}"; do
        if [[ "${array_to_search[i]}" == "$value_to_find" ]]; then
            index=$i
            break # Exit the loop as soon as the first match is found.
        fi
    done

    echo "$index"
}

# --- Main Execution ---
main() {
    local -a my_array=(34 23 12 98 76 55)
    local target1=12
    local target2=100

    echo "Searching for '$target1' in array: [${my_array[*]}]"
    local result1
    result1=$(linear_search "$target1" "${my_array[@]}")
    if ((result1 != -1)); then
        echo "✅ Found '$target1' at index: $result1"
    else
        echo "❌ '$target1' was not found in the array."
    fi

    echo ""
    echo "Searching for '$target2' in array: [${my_array[*]}]"
    local result2
    result2=$(linear_search "$target2" "${my_array[@]}")
    if ((result2 != -1)); then
        echo "✅ Found '$target2' at index: $result2"
    else
        echo "❌ '$target2' was not found in the array."
    fi
}

# --- Script Entry Point ---
main
