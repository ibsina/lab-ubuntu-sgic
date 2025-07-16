FROM nginx:latest

COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY server.crt /etc/nginx/server.crt
COPY server.key /etc/nginx/server.key

COPY html/ /var/www/html

EXPOSE 443

# Create a directory for access logs (adjust path if needed)
 RUN mkdir -p /var/log/nginx

# Mount the host directory for persistent logs
VOLUME ["/var/log/nginx:/var/log/nginx"]
# Volume mount for persistent configuration and logs
#VOLUME ["/etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro", "/var/log/nginx:/var/log/nginx"]


CMD ["nginx", "-g", "daemon off;"]
