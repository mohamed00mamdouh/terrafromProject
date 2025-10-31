#!/bin/bash
sudo yum install -y python3
sudo pip3 install flask
cat <<EOF | sudo tee /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return "Hello from Backend!"
app.run(host='0.0.0.0', port=80)
EOF
nohup python3 /home/ec2-user/app.py &
