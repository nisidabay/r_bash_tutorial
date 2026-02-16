# Bash RANDOM Function

The `$RANDOM` variable is a built-in Bash feature that generates a pseudo-random integer.

## What is `$RANDOM`?
- `$RANDOM` returns a random integer typically between 0 and 32767 (inclusive)
- It's useful for generating random numbers for various applications

## How to Use `$RANDOM`

### Basic Usage
```bash
random_number=$RANDOM
echo "Random number: $random_number"
```

### Generating Random Numbers in Specific Ranges
To generate a random number between 1 and 100:
```bash
random_number=$(( RANDOM % 100 + 1 ))
echo "Random number between 1 and 100: $random_number"
```

- `RANDOM % 100` gives a random number between 0 and 99
- Adding `1` shifts the range to 1 to 100

## Practical Examples

### Random File Name Generation
```bash
random_file_name="file_$(date +%s)_$RANDOM.txt"
echo "Generated file name: $random_file_name"
```

### Simulating Dice Rolls
```bash
dice_roll=$(( RANDOM % 6 + 1 ))
echo "Dice roll: $dice_roll"
```

### Random Selection from a List
```bash
options=("apple" "banana" "cherry")
random_option=${options[$(( RANDOM % ${#options[@]} ))]}
echo "Selected option: $random_option"
```

## Important Notes
- `$RANDOM` is not cryptographically secure
- It's suitable for non-security-related applications
- The randomness is generated using a pseudo-random number generator (PRNG)

## Example Script
```bash
#!/bin/bash

# Generate a random number between 1 and 100
random_number=$(( RANDOM % 100 + 1 ))

# Display the result
echo "Random number between 1 and 100: $random_number"

# Generate a random file name
file_name="data_$(date +%s)_$RANDOM.txt"
echo "Generated file name: $file_name"
```
