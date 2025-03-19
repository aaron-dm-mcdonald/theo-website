#!/bin/bash

# Update system packages
sudo apt update

# Install Python3, pip, and Git
sudo apt install -y python3 python3-pip git

# Set up the application directory
APP_DIR="/opt/theo-website"
REPO_URL="https://github.com/aaron-dm-mcdonald/theo-website.git"

# Clone the latest version from GitHub
sudo git clone $REPO_URL $APP_DIR
cd $APP_DIR

# Install dependencies system-wide
sudo pip install --break-system-packages -r requirements.txt

sudo touch /opt/theo-website/flask.log
sudo chmod 666 /opt/theo-website/flask.log

# Run Flask app in the background
sudo nohup python3 app.py > flask.log 2>&1 &
