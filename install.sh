#!/bin/bash

# Define the target directory where the swtp script will be placed
TARGET_DIR="/usr/local/bin"

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run as root to install swtp in $TARGET_DIR."
    echo "Please enter your root password to proceed:"
    sudo -v
    if [ $? -ne 0 ]; then
        echo "Incorrect password or operation cancelled. Exiting."
        exit 1
    fi
fi

# Download the latest tagged version of swtp script from the repository
LATEST_TAG=$(curl -s https://api.github.com/repos/kisztof/swtp/tags | grep -o '"name": "[^"]*' | head -n 1 | sed 's/"name": "//')
curl -L "https://github.com/kisztof/swtp/releases/download/$LATEST_TAG/swtp" -o "$TARGET_DIR/swtp"

# Make swtp executable
sudo chmod +x "$TARGET_DIR/swtp"

echo "swtp has been installed successfully in $TARGET_DIR."
