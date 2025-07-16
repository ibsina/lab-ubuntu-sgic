#!/bin/bash

# URL to access
URL="https://uat.acledainternetbank.com.kh/internetbank/login"

# Loop counter
counter=0

# Infinite Loop
while true
do
    # Print the current iteration
    echo "Request #$((counter + 1))"

    # Perform the curl request
    curl -k $URL &
    curl -k $URL &
    curl -k $URL &
    
    # Optional: Add a sleep interval if needed (e.g., sleep for 1 second)
    # sleep 1

    # Increment the counter
    counter=$((counter + 1))
done
