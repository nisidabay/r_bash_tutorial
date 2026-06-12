#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Comparing Arrays Using Namerefs (`local -n`)
#
# This script demonstrates how to use Bash 4.3+ "namerefs" to pass arrays
# by reference to functions that compare their contents.
# ==============================================================================

# --- Comparison Functions ---

# Compares if two arrays contain the same elements, regardless of order.
# It does this by sorting both arrays and then comparing their string representations.
# Usage: compare_contents_sorted array_one_name array_two_name
compare_contents_sorted() {
    local -n arr1_ref=$1 # Create a nameref to the first array
    local -n arr2_ref=$2 # Create a nameref to the second array

    # Create sorted copies of the arrays for comparison.
    # `readarray` (or `mapfile`) is used to read the output of the sort command
    # back into new local arrays.
    local -a sorted1
    local -a sorted2
    readarray -t sorted1 < <(printf '%s\n' "${arr1_ref[@]}" | sort)
    readarray -t sorted2 < <(printf '%s\n' "${arr2_ref[@]}" | sort)

    # Compare the sorted arrays by converting them to strings (`"${sorted1[*]}"`).
    # The `*` with quotes expands the array to a single string with elements
    # separated by the first character of IFS (a space by default, but we've
    # unset it, so it's clean).
    if [[ "${sorted1[*]}" == "${sorted2[*]}" ]]; then
        echo "✅ The arrays contain the same elements."
    else
        echo "❌ The arrays do NOT contain the same elements."
    fi
}

# Compares if two arrays are identical in both content AND order.
# It directly compares the string representations of the original arrays.
# Usage: compare_exact_order array_one_name array_two_name
compare_exact_order() {
    local -n arr1_ref=$1 # nameref to the first array
    local -n arr2_ref=$2 # nameref to the second array

    if [[ "${arr1_ref[*]}" == "${arr2_ref[*]}" ]]; then
        echo "✅ The arrays are identical in content and order."
    else
        echo "❌ The arrays are NOT identical in content and order."
    fi
}

# --- Main Execution ---
main() {
    # Example usage
    local -a array1=("apple" "banana" "cherry")
    local -a array2=("banana" "apple" "cherry")
    local -a array3=("apple" "banana" "cherry")

    echo "--- Test Case 1: Same elements, different order ---"
    echo "Array 1: ${array1[*]}"
    echo "Array 2: ${array2[*]}"
    compare_contents_sorted array1 array2 # Should be equal
    compare_exact_order array1 array2     # Should not be equal
    echo

    echo "--- Test Case 2: Same elements, same order ---"
    echo "Array 1: ${array1[*]}"
    echo "Array 3: ${array3[*]}"
    compare_contents_sorted array1 array3 # Should be equal
    compare_exact_order array1 array3     # Should be equal
    echo
}

# --- Script Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
