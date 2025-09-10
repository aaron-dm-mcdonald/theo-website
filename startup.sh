#!/bin/bash
set -e

# Update system
sudo dnf update -y

# Install dependencies
sudo dnf install -y python3-pip git

# Variables
APP_DIR="/opt/theo-website"
REPO_URL="https://github.com/aaron-dm-mcdonald/theo-website.git"

# Clone repo
sudo git clone $REPO_URL $APP_DIR
cd $APP_DIR

# Install Python dependencies
pip3 install -r requirements.txt

# Setup log file
sudo touch $APP_DIR/flask.log
sudo chmod 666 $APP_DIR/flask.log

# Start Flask app
echo "Starting Flask application..."
nohup python3 app.py > $APP_DIR/flask.log 2>&1 &
