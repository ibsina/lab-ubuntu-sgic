#!/bin/bash

# API endpoint
url="https://demo.fortiseahk.com/customers"

# Function to generate a random alphanumeric string
random_string() {
    local length=$1
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "$length"
}

# Function to generate a random email
random_email() {
    echo "$(random_string 8)@example.com"
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

    # Create random payload
    payload=$(cat <<EOF
{
    "id": $(shuf -i 1-10000 -n 1),
    "name": "$(random_string 6) $(random_string 6)",
    "address": "$(random_string 10) $(random_string 10) $(shuf -i 1-100 1)",
    "country": "$(random_string 10)"
}
EOF
    )

    # Send POST request with random X-Forwarded-For IP
    response=$(curl -s -w "%{http_code}" -o /dev/null -X POST "$url" \
        -H "Content-Type: application/json" \
        -H "X-Forwarded-For: $random_ip" \
        -d "$payload")

    # Log the result
#    curl https://demo.fortiseahk.com/customers -H "X-Forwarded-For: $random_ip"
#    curl https://demo.fortiseahk.com/users -H "X-Forwarded-For: $random_ip"
    echo "Request $i: HTTP $response, X-Forwarded-For: $random_ip"
done

