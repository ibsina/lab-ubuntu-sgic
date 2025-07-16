import requests
import random
import string
import json

# 2024062601 - Ferry Kemps : Initial script to create, login a random user on Juiceshop

# Function to generate a random username
def generate_random_username(length=8):
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))

# Function to create a random user on Juice Shop
def create_random_user(base_url):
    username = generate_random_username()
    password = 'Password123'  # Set a default password for simplicity

    # Endpoint for creating user on Juice Shop
    register_url = f"{base_url}/api/Users/"

    # Prepare data for registration
    user_data = {
        "email": f"{username}@example.com",
        "password": password,
        "passwordRepeat": password,
        "securityQuestion": "Your eldest siblings middle name?",
        "securityAnswer": "Juice",
        "terms": True
    }

    # Send POST request to create the user
    response = requests.post(register_url, json=user_data)

    if response.status_code == 201:
        print(f"User {username} created successfully!")
        return username, password
    else:
        print(f"Failed to create user. Status code: {response.status_code}")
        return None, None

# Function to login to Juice Shop
def login(base_url, username, password):
    login_url = f"{base_url}/rest/user/login"

    # Prepare login data
    login_data = {
        "email": f"{username}@example.com",
        "password": password
    }

    # Send POST request to login
    response = requests.post(login_url, json=login_data)

    if response.status_code == 200:
        print(f"Logged in as {username}!")
        # Extract the token or session cookie if needed
        # Example: token = response.json().get('authentication')['token']
        return True
    else:
        print(f"Login failed. Status code: {response.status_code}")
        return False

# Function to place an order on Juice Shop
def place_order(base_url, username):
    order_url = f"{base_url}/api/BasketItems"

    # Prepare order data
    order_data = {
        "ProductId": "1",  # Example product ID
        "quantity": 1
    }

    # Example headers with JWT token if required
    # headers = {
    #     "Authorization": f"Bearer {token}"
    # }

    # Send POST request to place order
    response = requests.post(order_url, json=order_data)

    if response.status_code == 200:
        print(f"Order placed successfully for {username}!")
    else:
        print(f"Failed to place order. Status code: {response.status_code}")

# Main function to orchestrate the process
def main():
    base_url = "http://juiceshop.fortiworkshop.nl"  # Replace with your Juice Shop base URL

    # Create a random user
    username, password = create_random_user(base_url)

    if username and password:
        # Login with the created user
        if login(base_url, username, password):
            # Place an order after successful login
            #place_order(base_url, username)
            print("Ready to place an order.")
            print("")
        else:
            print("Could not login. Exiting.")
    else:
        print("User creation failed. Exiting.")

if __name__ == "__main__":
    main()
