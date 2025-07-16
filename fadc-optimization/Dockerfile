# Use official Python image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .
RUN mkdir -p /app/app/static/images
RUN chmod 777 /app/app/static/images

# Set environment variables for Flask
ENV FLASK_APP=app/app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=production

# Expose port
EXPOSE 5000

# Run the Flask app
CMD ["flask", "run"]

