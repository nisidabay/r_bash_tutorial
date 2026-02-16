#!/usr/bin/env BASH
#
# Generate fake use data
generate_fake_data() {
    local name age email

    name=$(LC_ALL=C tr -dc 'a-zA-Z' </dev/urandom | head -c 5)
    age=$((RANDOM % 60 + 20))
    email="${name,,}@example.com"

    echo "$name, $age, $email"
}

# Use Process Substitution < <(...) to fill the array directly
mapfile -t data_rows < <(for ((i = 1; i <= 5; i++)); do generate_fake_data; done)

echo "Created ${#data_rows[@]}: users"
for name in "${data_rows[@]}"; do
    echo "$name"
done
