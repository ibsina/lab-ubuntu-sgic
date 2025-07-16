from flask import Flask, render_template, request, redirect, url_for, session, jsonify
import mysql.connector
import os

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "mysecret")

# Database Configuration
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_NAME = os.getenv("DB_NAME", "flaskapp")

def get_db_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

# Home (Login Page)
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM users WHERE username=%s AND password=%s", (username, password))
        user = cursor.fetchone()
        conn.close()
        
        if user:
            session['user_id'] = user[0]
            session['username'] = username
            return redirect(url_for('dashboard'))
        else:
            return "Invalid Credentials!", 401
    
    return render_template('login.html')

# User Registration
@app.route('/adduser', methods=['GET', 'POST'])
def adduser():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        conn.close()
        
        return redirect(url_for('login'))
    
    return render_template('adduser.html')

# Dashboard (Restricted to Logged-in Users)
@app.route('/dashboard', methods=['GET', 'POST'])
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    if request.method == 'POST':
        comment = request.form['comment']
        cursor.execute("INSERT INTO comments (user_id, comment) VALUES (%s, %s)", (session['user_id'], comment))
        conn.commit()
    
    cursor.execute("SELECT users.username, comments.comment FROM comments JOIN users ON comments.user_id = users.id ORDER BY comments.id DESC")
    comments = cursor.fetchall()
    conn.close()
    
    return render_template('dashboard.html', username=session['username'], comments=comments)

# Logout (Clears Session)
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# API to Check Login Status
@app.route('/status')
def status():
    if 'user_id' in session:
        return jsonify({"logged_in": True, "username": session['username']})
    return jsonify({"logged_in": False})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

