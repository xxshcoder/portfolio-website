# Use lightweight Nginx image
FROM nginx:alpine

# Copy your HTML files into Nginx's default serving directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
