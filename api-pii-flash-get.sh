#!/bin/bash

# Random ID Generator for User and Customer
generate_random_id() {
  echo $((RANDOM % 1000 + 1))
}

# Generate Random IP for X-Forwarded-For Header
generate_random_ip() {
  echo "$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1))"
}

# Number of requests to simulate (500 requests)
num_requests=500

# Loop to simulate multiple GET requests
for ((i = 1; i <= num_requests; i++)); do
  # Random ID for user and customer
  user_id=$(generate_random_id)
  customer_id=$(generate_random_id)

  # Random Public IP for X-Forwarded-For header
  random_ip=$(generate_random_ip)

  # Send GET request for user with random ID
  curl -X GET "http://localhost:5000/users/$user_id" \
    -H "X-Forwarded-For: $random_ip"

  # Send GET request for customer with random ID
  curl -X GET "http://localhost:5000/customers/$customer_id" \
    -H "X-Forwarded-For: $random_ip"

  echo "Request $i completed"
done

