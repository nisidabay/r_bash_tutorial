#!/usr/bin/env BASH

# Function to increment a variable passed by reference
increment_variable() {
    local -n ref="$1"
    ((ref++))
}

# Example 1: Looping Constructs
echo "Example 1: Looping Constructs"
my_count=0
for i in {1..5}; do
    increment_variable my_count
    echo "Current count: $my_count"
done

# Example 2: Recursive Functions
echo "\nExample 2: Recursive Functions"
function recursive_function() {
    local -n ref="$1"
    if ((ref < 5)); then
        ((ref++))
        echo "Current level: $ref"
        recursive_function my_level
    fi
}

my_level=0
recursive_function my_level

# Example 3: Counting Occurrences
echo "\nExample 3: Counting Occurrences"
function count_items() {
    local -n ref="$1"
    if [[ "$item" == "apple" ]]; then
        ((ref++))
    fi
}

my_apple_count=0
for item in apple banana apple orange; do
    count_items my_apple_count
done
echo "Number of apples: $my_apple_count"

# Example 4: Tracking Progress
echo "\nExample 4: Tracking Progress"
function process_files() {
    local -n ref="$1"
    for file in "$@"; do
        # Simulate processing the file...
        sleep 0.5
        ((ref++))
        echo "Processed $file ($ref/$#)"
    done
}

my_processed_count=0
files=("file1.txt" "file2.txt" "file3.txt")
process_files my_processed_count "${files[@]}"

# Example 5: Dynamic Data Manipulation
echo "\nExample 5: Dynamic Data Manipulation"
function update_stats() {
    local -n ref="$1"
    if ((ref % 2 == 0)); then
        echo "Even number encountered"
    else
        echo "Odd number encountered"
    fi
    ((ref++))
}

my_number_count=0
for num in {1..5}; do
    update_stats my_number_count
done
