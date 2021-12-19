#!/bin/bash

# Update Amazon Linux
yum update -y

# Install and start ngnix
amazon-linux-extras install -y nginx1
systemctl start nginx

# Install Tools
yum install -y lynx
yum install -y jq
# Create a web page with hostname
echo "<html><body><h1>Instance Name: $(curl http://169.254.169.254/latest/meta-data/hostname)<h1></body></html>" > /usr/share/nginx/html/index.html

# Wait for 1min in order S3 to complete initialisation
sleep 1m

# Copy index.html to s3 storage for backup purposes (filename format: <date>_<time>_<hostname>-index.html)
aws s3 cp /usr/share/nginx/html/index.html s3://tf-s3-bucket-alexeyput/$(date +"%Y-%m-%d_%H-%M")_$(hostname)-index.html