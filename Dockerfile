# Use lightweight Nginx image
FROM nginx:alpine

# Metadata
LABEL maintainer="Santosh Dhakal <your-email@example.com>"
LABEL version="1.0"
LABEL description="Portfolio website served by Nginx"

# Copy your website files into Nginx's default serving directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
