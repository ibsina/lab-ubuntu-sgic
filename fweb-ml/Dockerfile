# Use an official PHP-FPM base image with NGINX
FROM php:7.4-fpm-alpine

# Install NGINX and necessary packages
RUN apk --no-cache add nginx curl \
    && mkdir -p /run/nginx

# Copy the NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the HTML and PHP files to the document root
COPY html/ /usr/share/nginx/html

# Set the appropriate permissions
RUN chown -R www-data:www-data /usr/share/nginx/html

# Expose port 80 for incoming web traffic
EXPOSE 80

# Start PHP-FPM and NGINX
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]

