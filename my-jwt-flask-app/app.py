from flask import Flask, jsonify, request
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = 'fortinet-4awesome'  # Change this to a strong secret key
jwt = JWTManager(app)

# In-memory storage for users (use a database for production)
users = {}

@app.route('/')
def index():
    return "Welcome to the API!"

@app.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')

    if username in users:
        return jsonify({"msg": "User already exists!"}), 400

    hashed_password = generate_password_hash(password)
    users[username] = hashed_password
    return jsonify({"msg": "User registered successfully!"}), 201

@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')

    user_password = users.get(username)
    if user_password and check_password_hash(user_password, password):
        access_token = create_access_token(identity=username)
        return jsonify(access_token=access_token), 200

    return jsonify({"msg": "Bad username or password"}), 401

@app.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    return jsonify(msg="This is a protected route"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8030)
