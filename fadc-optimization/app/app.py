from flask import Flask, render_template, request, redirect, url_for, send_from_directory, jsonify
import os
from werkzeug.utils import secure_filename
from PIL import Image
from datetime import datetime

UPLOAD_FOLDER = 'static/images'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        if 'file' not in request.files:
            return 'No file part', 400
        file = request.files['file']
        if file.filename == '':
            return 'No selected file', 400
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('index'))
    return '''
        <!doctype html>
        <title>Upload Image</title>
        <h1>Upload New Image</h1>
        <form method=post enctype=multipart/form-data>
          <input type=file name=file>
          <input type=submit value=Upload>
        </form>
    '''

@app.route('/api/data')
def api_data():
    return jsonify({
        'message': 'System running normally',
        'timestamp': datetime.utcnow().isoformat()
    })

@app.route('/api/images')
def api_images():
    image_data = []
    for filename in os.listdir(app.config['UPLOAD_FOLDER']):
        if allowed_file(filename):
            path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            try:
                with Image.open(path) as img:
                    width, height = img.size
                size_kb = os.path.getsize(path) // 1024
                image_data.append({
                    'filename': filename,
                    'width': width,
                    'height': height,
                    'size_kb': size_kb
                })
            except Exception:
                continue
    return jsonify(sorted(image_data, key=lambda x: x['filename']))

