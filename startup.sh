#!/bin/bash



until sudo apt update -qq; do
  echo "apt update failed. Retrying in 5 seconds..."
  sleep 5
done


until sudo apt install -y python3 python3-pip git; do
  echo "apt install failed. Retrying in 5 seconds..."
  sleep 5
done

APP_DIR="/opt/theo-website"
REPO_URL="https://github.com/aaron-dm-mcdonald/theo-website.git"


sudo git clone $REPO_URL $APP_DIR
cd $APP_DIR

sudo pip install --break-system-packages -r requirements.txt


sudo touch /opt/theo-website/flask.log
sudo chmod 666 /opt/theo-website/flask.log

echo "Starting Flask application..."
nohup python3 app.py > flask.log 2>&1 &



