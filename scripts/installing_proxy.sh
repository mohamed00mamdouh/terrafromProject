#!/bin/bash
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "<h1>Welcome to Proxy</h1>" | sudo tee /usr/share/nginx/html/index.html
