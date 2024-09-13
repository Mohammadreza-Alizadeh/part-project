#!/bin/bash

# Define the install directories
BIN_DIR="/usr/local/bin"
TOOL_DIR="/usr/local/share/part-tools"

mkdir -p /usr/local/bin
mkdir -p /usr/local/share/part-tools

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Create the directory for private tools
mkdir -p "$TOOL_DIR"

# Install interface.sh in /usr/local/bin
echo "Installing part to $BIN_DIR..."
cp part "$BIN_DIR/part"
chmod +x "$BIN_DIR/part"

# Install tool1.sh and other tools in the private directory
echo "Installing tools to $TOOL_DIR..."
cp change-sources.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/change-sources.sh"

cp create-user.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/create-user.sh"

cp config-nft.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/config-nft.sh"

cp config-ntp.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/config-ntp.sh"

cp config-ssh.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/config-ssh.sh"

cp data-collector.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/data-collector.sh"

cp setup-cron.sh "$TOOL_DIR/"
chmod +x "$TOOL_DIR/setup-cron.sh"


echo "Installation complete!"
