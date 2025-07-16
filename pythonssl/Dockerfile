# Use a slim Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy app.py and templates directory (containing index.html)
COPY app.py index.html /app

# Expose port for web traffic (adjust if needed)
EXPOSE 5000

# Define environment variable for certificate path (modify as needed)
ENV SSL_CERT_PATH=/etc/ssl/certs

# Command to run the application (modify based on your framework)
CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "--cert-file", "$SSL_CERT_PATH/server.crt", "--key-file", "$SSL_CERT_PATH/server.key", "app:app" ]
