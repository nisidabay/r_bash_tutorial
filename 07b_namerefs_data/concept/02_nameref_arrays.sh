#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Advanced Variable and Array Manipulation with Namerefs (`local -n`)
#
# This script demonstrates how to use Bash 4.3+ "namerefs" to pass both
# standard variables and arrays to functions by reference. This allows the
# functions to directly modify the original variables/arrays in the calling scope.
#
# A nameref (`local -n`) creates a local variable that is an alias for another
# variable.
# ==============================================================================

# --- Global Variables (State) ---
count=0
users=("alpha" "beta" "gamma" "teta")
a=(1 2 3)
b=(4 5 6)
target_var=100

# --- Functions that Modify State via References ---

# Increments any variable whose name is passed as an argument.
# Usage: increment_variable my_var_name
increment_variable() {
    local -n ref_to_var="$1"
    ((ref_to_var++))
}

# Removes a specified element from an array. The array is passed by reference.
# This implementation is safe as it rebuilds the array, preserving indices
# if it were an associative array and creating a clean, sparse-less indexed array.
# Usage: remove_element_from_array my_array_name "element_to_remove"
remove_element_from_array() {
    local -n array_ref="$1"
    local element_to_remove="$2"
    local new_array=() # Temporary array to hold the filtered elements

    for element in "${array_ref[@]}"; do
        if [[ "$element" != "$element_to_remove" ]]; then
            new_array+=("$element")
        fi
    done

    # Overwrite the original array with the new, filtered array.
    array_ref=("${new_array[@]}")
}

# Swaps the contents of two arrays passed by reference.
# Usage: swap_arrays array_one_name array_two_name
swap_arrays() {
    local -n ref_a="$1"
    local -n ref_b="$2"

    # Use a temporary array to hold the contents of the first array.
    local tmp_array=("${ref_a[@]}")
    # Assign the second array's content to the first.
    ref_a=("${ref_b[@]}")
    # Assign the temporary (original first) array's content to the second.
    ref_b=("${tmp_array[@]}")
}

# --- Main Execution Block ---

main() {
    echo "--- Initial State ---"
    printf "Count: %s\n" "$count"
    printf "Target Var: %s\n" "$target_var"
    # Using printf for safe array printing is a good habit.
    printf "Users: %s\n" "${users[*]}"
    printf "Array a: %s\n" "${a[*]}"
    printf "Array b: %s\n" "${b[*]}"
    echo

    echo "--- Operations ---"

    echo "▶ Incrementing 'count'..."
    increment_variable "count"
    printf "  New count: %s\n\n" "$count"

    echo "▶ Incrementing 'target_var'..."
    increment_variable "target_var"
    printf "  New target_var: %s\n\n" "$target_var"

    echo "▶ Removing 'teta' from 'users'..."
    remove_element_from_array "users" "teta"
    printf "  New users array: %s\n\n" "${users[*]}"

    echo "▶ Swapping arrays 'a' and 'b'..."
    swap_arrays "a" "b"
    printf "  New array a: %s\n" "${a[*]}"
    printf "  New array b: %s\n\n" "${b[*]}"

    echo "--- Final State ---"
    printf "Count: %s\n" "$count"
    printf "Target Var: %s\n" "$target_var"
    printf "Users: %s\n" "${users[*]}"
    printf "Array a: %s\n" "${a[*]}"
    printf "Array b: %s\n" "${b[*]}"
}

# Run the main function if the script is executed directly.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
