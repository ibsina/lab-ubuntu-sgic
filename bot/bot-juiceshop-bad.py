import requests
import random
import string
import json

# 2024062601 - Ferry Kemps : Initial script to simulate failed login attempts on Juiceshop

# Function to fail login to Juice Shop
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

# Main function to orchestrate the process
def main():
    username = 'admin@example.com'
    password = 'Password123'  # Set a bogus password
    base_url = "http://juiceshop.fortiworkshop.nl"  # Replace with your Juice Shop base URL

    if username and password:
        # Login with the created user
        if login(base_url, username, password):
            print("")
        else:
            print("Could not login. Exiting.")
            print("")

if __name__ == "__main__":
    main()
