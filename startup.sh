#!/bin/bash

# Update system packages
apt update && apt upgrade -y

# Install Python3, pip, and Git
apt install -y python3 python3-pip python3-venv git

# Set up the application directory
APP_DIR="/opt/theo-website"
REPO_URL="https://github.com/aaron-dm-mcdonald/theo-website.git"


# Clone the latest version from GitHub
git clone $REPO_URL $APP_DIR
cd $APP_DIR

# Set up Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run Flask app in the background
nohup python3 app.py > flask.log 2>&1 &
