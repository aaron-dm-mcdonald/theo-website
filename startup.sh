#!/bin/bash

# Update system packages, install needed packages
sudo apt update
sudo apt install -y python3 python3-pip git


# Clone the latest version from GitHub
sudo git clone https://github.com/aaron-dm-mcdonald/theo-website.git /opt/website
cd /opt/website

# Install dependencies system-wide
sudo pip install --break-system-packages -r requirements.txt

sudo touch /opt/theo-website/flask.log
sudo chmod 666 /opt/theo-website/flask.log

# Run Flask app in the background
sudo nohup python3 app.py > flask.log 2>&1 &
