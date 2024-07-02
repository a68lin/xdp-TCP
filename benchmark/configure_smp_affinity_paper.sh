#!/bin/bash

# Check if script is executed with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Define the list of values to replace
VALUES=("00001" "00002" "00004" "00008" "00010" "00020" "00040" "00080" "00100" "00200" "100000" "200000" "400000" "800000" "1000000" "2000000" "4000000" "8000000" "10000000" "20000000")
# Start IRQ number
IRQ_NUMBER=162

# Iterate over IRQ numbers
for VALUE in "${VALUES[@]}"; do
    FILE="/proc/irq/$IRQ_NUMBER/smp_affinity"

    # Check if the file exists
    if [ ! -e "$FILE" ]; then
        echo "File $FILE not found. Skipping."
        continue
    fi

    # Replace the current value with the new value
    echo "$VALUE" > "$FILE"

    # Check if the replacement was successful
    if [ $? -ne 0 ]; then
        echo "Error replacing value in $FILE"
        exit 1
    fi

    echo "Replaced value in $FILE with $VALUE"

    # Increment IRQ number
    IRQ_NUMBER=$((IRQ_NUMBER + 1))
done

echo "Values replaced successfully."