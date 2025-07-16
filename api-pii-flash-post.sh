#!/bin/bash

# Random Data Generation Functions
generate_random_name() {
  names=("John Doe" "Jane Smith" "Alice Johnson" "Bob Williams" "Charlie Brown" "David Lee")
  echo "${names[$RANDOM % ${#names[@]}]}"
}

generate_random_email() {
  domains=("example.com" "gmail.com" "yahoo.com" "outlook.com")
  echo "$(generate_random_name | tr -d ' ' | tr '[:upper:]' '[:lower:]')@${domains[$RANDOM % ${#domains[@]}]}"
}

generate_random_credit_card() {
  echo "$((RANDOM % 9000 + 1000))-$(RANDOM % 9000 + 1000)-$(RANDOM % 9000 + 1000)-$(RANDOM % 9000 + 1000)"
}

generate_random_passport() {
  echo "P$(shuf -i 1000000-9999999 -n 1)"
}

generate_random_address() {
  streets=("123 Elm St" "456 Oak Ave" "789 Pine Rd" "101 Maple Dr" "202 Birch Ln")
  cities=("New York" "Los Angeles" "Chicago" "Houston" "Phoenix")
  countries=("USA" "Canada" "UK" "Germany" "Australia")
  echo "${streets[$RANDOM % ${#streets[@]}]}, ${cities[$RANDOM % ${#cities[@]}]}, ${countries[$RANDOM % ${#countries[@]}]}"
}

# Generate Random IP for X-Forwarded-For Header
generate_random_ip() {
  echo "$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1)).$((RANDOM % 255 + 1))"
}

# Number of requests to simulate (500 requests)
num_requests=500

# Loop to simulate multiple requests
for ((i = 1; i <= num_requests; i++)); do
  # Random Data for User
  user_name=$(generate_random_name)
  user_email=$(generate_random_email)
  user_credit_card=$(generate_random_credit_card)
  user_passport=$(generate_random_passport)

  # Random Data for Customer
  customer_name=$(generate_random_name)
  customer_address=$(generate_random_address)
  customer_country=$(generate_random_country)

  # Random Public IP for X-Forwarded-For header
  random_ip=$(generate_random_ip)

  # Random ID for user and customer
  user_id=$((RANDOM % 1000 + 1))
  customer_id=$((RANDOM % 1000 + 1))

  # User JSON Payload
  user_payload=$(cat <<EOF
{
  "id": $user_id,
  "name": "$user_name",
  "email": "$user_email",
  "credit-card": "$user_credit_card",
  "passport": "$user_passport"
}
EOF
)

  # Customer JSON Payload
  customer_payload=$(cat <<EOF
{
  "id": $customer_id,
  "name": "$customer_name",
  "address": "$customer_address",
  "country": "$customer_country"
}
EOF
)

  # Send POST request for user
  curl -X POST http://localhost:5000/users \
    -H "Content-Type: application/json" \
    -H "X-Forwarded-For: $random_ip" \
    -d "$user_payload"

  # Send POST request for customer
  curl -X POST http://localhost:5000/customers \
    -H "Content-Type: application/json" \
    -H "X-Forwarded-For: $random_ip" \
    -d "$customer_payload"

  echo "Request $i completed"
done

