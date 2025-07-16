from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def index():
  client_ip = request.remote_addr
  forwarded_ip = request.headers.get('X-Forwarded-For')
  return render_template("index.html", client_ip=client_ip, forwarded_ip=forwarded_ip)

if __name__ == "__main__":
  app.run(debug=True)

