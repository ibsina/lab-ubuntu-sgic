from flask import Flask, request, jsonify
import json

app = Flask(__name__)

# File paths for storing data
USERS_FILE = 'data/users.json'
CUSTOMERS_FILE = 'data/customers.json'

# Utility function to read data from JSON file
def read_data(file_path):
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return []

# Utility function to write data to JSON file
def write_data(file_path, data):
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=4)

# Route to create a new user
@app.route('/users', methods=['POST'])
def create_user():
    users = read_data(USERS_FILE)
    data = request.json

    # Validate that 'name' is provided
    if not data.get('name'):
        return jsonify({'error': 'The "name" field is required'}), 400

    # Add the new user
    user = {
        'id': len(users) + 1,  # Generate a new ID
        'name': data['name'],
        'email': data.get('email', ''),
        'credit-card': data.get('credit-card', ''),
        'passport': data.get('passport', '')
    }
    users.append(user)
    write_data(USERS_FILE, users)

    return jsonify(user), 201
#route to view users
@app.route('/users', methods=['GET'])
def get_users_file():
    try:
        with open(USERS_FILE, 'r') as f:
            data = json.load(f)
        return jsonify(data)
    except FileNotFoundError:
        return jsonify([]), 404

#route to view customers
@app.route('/customers', methods=['GET'])
def get_customers_file():
    try:
        with open(CUSTOMERS_FILE, 'r') as f:
            data = json.load(f)
        return jsonify(data)
    except FileNotFoundError:
        return jsonify([]), 404

# Route to create a new customer
@app.route('/customers', methods=['POST'])
def create_customer():
    customers = read_data(CUSTOMERS_FILE)
    data = request.json

    # Validate that 'name' is provided
    if not data.get('name'):
        return jsonify({'error': 'The "name" field is required'}), 400

    # Add the new customer
    customer = {
        'id': len(customers) + 1,  # Generate a new ID
        'name': data['name'],
        'address': data.get('address', ''),
        'country': data.get('country', '')
    }
    customers.append(customer)
    write_data(CUSTOMERS_FILE, customers)

    return jsonify(customer), 201

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

