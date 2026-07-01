#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================================
# Modifying Variables by Reference with `local -n` (namerefs)
#
# This script demonstrates a powerful Bash 4.3+ feature called "namerefs"
# (`local -n`). A nameref is a variable that acts as an alias or a reference
# to another variable.
#
# When you declare `local -n ref="some_other_var"`, any operation performed on
# `ref` inside the function will actually affect `some_other_var` in the
# calling scope. This allows functions to modify variables outside their own
# scope without using global variables or complex `eval` statements.
#
# This is the modern and safe way to achieve pass-by-reference behavior in Bash.
# ==============================================================================

# --- The Core Function ---
# This function takes the name of a variable as its first argument.
# It creates a reference (`ref`) to that variable and increments its value.
increment_variable() {
    # `local -n ref="$1"`: `ref` now points to the variable whose name was passed in.
    local -n ref="$1"
    # `((ref++))`: This arithmetic operation modifies the original variable.
    ((ref++))
}

# --- Examples ---

# Example 1: Simple Loop Counter
echo "--- Example 1: Looping Constructs ---"
my_count=0
# shellcheck disable=SC2034  # intentional: loop variable, used by increment_variable via nameref
for i in {1..5}; do
    # Pass the *name* of the variable to the function.
    increment_variable my_count
    echo "Current count: $my_count"
done

# Example 2: Recursive Functions
echo -e "\n--- Example 2: Recursive Functions ---"
# Note: Namerefs can make recursion that modifies state much cleaner.
recursive_function() {
    # `ref` becomes a reference to the variable passed in (e.g., `my_level`).
    local -n ref="$1"
    if ((ref < 5)); then
        ((ref++))
        echo "Current level: $ref"
        # The reference is passed down the recursive calls.
        recursive_function "$1"
    fi
}

# shellcheck disable=SC2034  # intentional: recursion counter modified via nameref
my_level=0
recursive_function my_level

# Example 3: Counting Occurrences in a Loop
echo -e "\n--- Example 3: Counting Occurrences ---"
# This function increments a counter if the global variable 'item' is "apple".
count_items() {
    local -n ref="$1"
    # This function depends on a variable `item` from the calling loop's scope.
    # A better design would be to pass `item` as a second argument.
    if [[ "$item" == "apple" ]]; then
        ((ref++))
    fi
}

my_apple_count=0
for item in apple banana apple orange; do
    count_items my_apple_count
done
echo "Number of apples: $my_apple_count"

# Example 4: Tracking Progress of a Batch Operation
echo -e "\n--- Example 4: Tracking Progress ---"
process_files() {
    local -n progress_ref="$1"
    shift # Remove the ref name from the arguments list.
    local -a files_to_process=("$@")
    local total_files=${#files_to_process[@]}

    for file in "${files_to_process[@]}"; do
        # Simulate processing the file...
        sleep 0.1
        # Increment the counter in the parent scope.
        ((progress_ref++))
        echo "Processed '$file' ($progress_ref/$total_files)"
    done
}

my_processed_count=0
files=("file1.txt" "file2.txt" "file3.txt")
process_files my_processed_count "${files[@]}"
echo "Total files processed: $my_processed_count"

# Example 5: Dynamic State Inside a Loop
echo -e "\n--- Example 5: Dynamic Data Manipulation ---"
update_stats() {
    local -n ref_count="$1"
    # Perform some action based on the state of the counter.
    if ((ref_count % 2 == 0)); then
        echo "State: Even number encountered ($ref_count)"
    else
        echo "State: Odd number encountered ($ref_count)"
    fi
    # Increment the counter for the next iteration.
    ((ref_count++))
}

# shellcheck disable=SC2034  # intentional: counter modified via nameref
my_number_count=0
# shellcheck disable=SC2034  # intentional: loop variable
for num in {1..5}; do
    update_stats my_number_count
done
