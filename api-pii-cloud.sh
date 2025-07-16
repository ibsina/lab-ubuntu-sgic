#!/bin/bash

# API endpoint
url="https://demo.fortiseahk.com/users"

# Function to generate a random alphanumeric string with a length between 8 and 20
random_string() {
    local length=$(shuf -i 3-6 -n 1)  # Random length between 8 and 20
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length"
}

# Function to generate a random email with a variable-length username
random_email() {
    echo "$(random_string)@example.com"
}

# Function to generate a random credit card number
random_credit_card() {
    echo "$(shuf -i 4000-4999 -n 1)-$(shuf -i 1000-9999 -n 1)-$(shuf -i 1000-9999 -n 1)-$(shuf -i 1000-9999 -n 1)"
}

# Function to generate a random passport number
random_passport() {
    echo "$(tr -dc 'A-Z' < /dev/urandom | head -c 1)$(shuf -i 1000000-9999999 -n 1)"
}

# Function to generate a random public IP
random_ip() {
    echo "$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1)"
}

# Loop to send 500 requests
for i in {1..500}
do
    # Generate random X-Forwarded-For IP
    random_ip=$(random_ip)

    # Generate random-length name (first and last name)
    random_name="$(random_string) $(random_string)"

    # Generate random-length email
    random_email=$(random_email)

    # Create random payload
    payload=$(cat <<EOF
{
    "id": $(shuf -i 1-10000 -n 1),
    "name": "$random_name",
    "email": "$random_email",
    "credit-card": "$(random_credit_card)",
    "passport": "$(random_passport)"
}
EOF
    )

    # Send POST request with random X-Forwarded-For IP
    response=$(curl -s -w "%{http_code}" -o /dev/null -X POST "$url" \
        -H "Content-Type: application/json" \
        -H "X-Forwarded-For: $random_ip" \
	-H "key: cJIyPIz1rhTxrM6juJSupUTkHCqKAFlbPOT9EJVh" \
        -d "$payload")

    # Log the result
    echo "Request $i: HTTP $response, X-Forwarded-For: $random_ip"
done

