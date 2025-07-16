#!/bin/bash

# Number of concurrent curl requests
CONCURRENT_REQUESTS=5

# URL to access
URL="https://fad-llb.cbcgslb.fortiseahk.com:8888/"

# Function to generate a random IP address
generate_random_ip() {
    echo "$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# Function to perform curl request in an infinite loop
perform_curl() {
    local counter=0
    while true
    do
        # Generate a random IP for X-Forwarded-For header
        XFF=$(generate_random_ip)

        # Print the current iteration and process ID
        echo "Request #$((counter + 1)) from PID $$ with XFF $XFF"

        # Perform the curl request with X-Forwarded-For header
        curl -k -H "X-Forwarded-For: $XFF" $URL
        
        # Optional: Add a sleep interval if needed (e.g., sleep for 1 second)
        # sleep 1

        # Increment the counter
        counter=$((counter + 1))
    done
}

# Start multiple curl requests concurrently
for ((i=1; i<=CONCURRENT_REQUESTS; i++))
do
    perform_curl &
done

# Wait for all background jobs to finish
wait
