# Use the official PHP image as a base image
FROM php:8.1-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the SSL certificates
COPY server.crt /etc/nginx/server.crt
COPY server.key /etc/nginx/server.key

# Copy the PHP code into the container
COPY index.php /var/www/html/index.php

# Set the working directory
WORKDIR /var/www/html

# Expose port 443 for HTTPS
EXPOSE 443

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "php-fpm && nginx -g 'daemon off;'"]

