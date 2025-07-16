#!/bin/bash

# Number of requests to send
TOTAL_REQUESTS=500

# Target URL base
BASE_URL="http://api-pii.demo"

# Delay between requests (in seconds)
DELAY=0.1

echo "Sending $TOTAL_REQUESTS requests to $BASE_URL with random paths..."

for ((i=1; i<=TOTAL_REQUESTS; i++)); do
    # Generate a random path like /abc123 or /v1/test/xyz
    RANDOM_PATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $((RANDOM % 10 + 5)) | head -n 1)
    
    # Construct full URL
    FULL_URL="${BASE_URL}/${RANDOM_PATH}"
    #FULL_URL="${BASE_URL}/test"

    # Send request and capture HTTP status code only
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$FULL_URL")

    # Output result
    echo "[$i] GET $FULL_URL => HTTP $STATUS_CODE"

    # Optional: simulate slight delay
    sleep $DELAY
done

