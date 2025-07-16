from flask import Flask, render_template, request, redirect, url_for, session, make_response
import mysql.connector
import hashlib

app = Flask(__name__, static_folder='static', template_folder='templates')
app.secret_key = "mysecret"

# Database Configuration
db_config = {
    "host": "172.19.8.82",
    "user": "cbc",
    "password": "fortinet",
    "database": "flaskapp"
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

# Hash password
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# ===== NORMAL PAGES =====
@app.route("/", methods=["GET", "POST"])
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
   #     password = hash_password(request.form["password"])

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM users WHERE username=%s AND password=%s", (username, password))
        user = cursor.fetchone()
        conn.close()

        if user:
            session['user_id'] = user[0]
            session['username'] = username
            return redirect(url_for('dashboard'))
            resp.set_cookie("session", username)
            return resp
        else:
            return "Invalid Credentials!", 401

    return render_template("login.html")

@app.route("/adduser", methods=["GET", "POST"])
def adduser():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form['password']
      #  password = hash_password(request.form["password"])

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        conn.close()

        return redirect(url_for("login"))

    return render_template("adduser.html")

@app.route("/dashboard", methods=["GET", "POST"])
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


@app.route("/logout")
def logout():
    session.pop("username", None)
    resp = make_response(redirect(url_for("login")))
    resp.delete_cookie("session")
    return resp

# ===== MOBILE PAGES =====
@app.route("/mobile/login", methods=["GET", "POST"])
def mobile_login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form['password']
      #  password = hash_password(request.form["password"])

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
        user = cursor.fetchone()
        conn.close()

        if user:
            session["username"] = username
            resp = make_response(redirect(url_for("mobile_dashboard")))
            resp.set_cookie("session", username)
            return resp
        else:
            return "Invalid credentials"

    return render_template("mobile/login.html")

@app.route("/mobile/adduser", methods=["GET", "POST"])
def mobile_adduser():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form['password']
       # password = hash_password(request.form["password"])

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        conn.close()

        return redirect(url_for("mobile_login"))

    return render_template("mobile/adduser.html")

@app.route("/mobile/dashboard", methods=["GET", "POST"])
def mobile_dashboard():
    if 'user_id' not in session:
        return redirect(url_for("mobile_login"))
    
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


@app.route("/mobile/logout")
def mobile_logout():
    session.pop("username", None)
    resp = make_response(redirect(url_for("mobile_login")))
    resp.delete_cookie("session")
    return resp

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

