# Use the official Nginx image as the base image
FROM nginx:latest

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy certificates and keys
COPY server.crt /etc/ssl/certs/server.crt
COPY server.key /etc/ssl/private/server.key
COPY ca.crt /etc/ssl/certs/ca.crt

# Expose port 443 for HTTPS
EXPOSE 443

