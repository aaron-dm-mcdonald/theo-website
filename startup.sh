#!/bin/bash

set -e  # Stop script on first error
exec > /var/log/startup-script.log 2>&1  # Log all output

echo "Waiting for package manager lock..."
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
  echo "Waiting for dpkg lock to be released..."
  sleep 5
done

echo "Updating package lists..."
until sudo apt update -qq; do
  echo "apt update failed. Retrying in 5 seconds..."
  sleep 5
done

echo "Installing required packages..."
until sudo apt install -y python3 python3-pip git; do
  echo "apt install failed. Retrying in 5 seconds..."
  sleep 5
done

APP_DIR="/opt/theo-website"
REPO_URL="https://github.com/aaron-dm-mcdonald/theo-website.git"

echo "Cloning repository..."
sudo git clone $REPO_URL $APP_DIR
cd $APP_DIR

echo "Installing Python dependencies..."
sudo pip install --break-system-packages -r requirements.txt

echo "Setting up Flask log file..."
sudo touch /opt/theo-website/flask.log
sudo chmod 666 /opt/theo-website/flask.log

echo "Starting Flask application..."
nohup python3 app.py > flask.log 2>&1 &

echo "Startup script execution completed successfully."

