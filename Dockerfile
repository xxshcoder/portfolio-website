# Use lightweight Nginx image
FROM nginx:alpine

# Copy your website files into Nginx's default serving directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
