# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Flask and Flask-JWT-Extended
RUN pip install Flask Flask-JWT-Extended

# Expose the port the app runs on
EXPOSE 8030

# Define the command to run the app
CMD ["python", "app.py"]
