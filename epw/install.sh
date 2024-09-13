#!/bin/bash

INSTALL_DIR="/opt/data/epweather"
DB_DIR="$INSTALL_DIR/db"
SCRIPT="epwtr"
CITIES_FILE="$DB_DIR/cities.txt"
LOG_DIR="/var/log/epweather"
LOG_FILE="$LOG_DIR/epw.log"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or using sudo!" 1>&2
   exit 1
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$DB_DIR"
mkdir -p "$LOG_DIR"


cp "$SCRIPT" "$INSTALL_DIR/$SCRIPT"
chmod +x "$INSTALL_DIR/$SCRIPT"  # Make the script executable

touch "$CITIES_FILE"
touch "$LOG_FILE"

mkdir -p "/usr/local/bin"
ln -s "$INSTALL_DIR/$SCRIPT" "/usr/local/bin/epw"

chmod 777 "$INSTALL_DIR"
chmod 777 "$DB_DIR"
chmod 666 "$CITIES_FILE"
chmod 777 "$LOG_DIR"
chmod 666 "$LOG_FILE"
