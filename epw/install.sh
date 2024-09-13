#!/bin/bash

INSTALL_DIR="/opt/data/epweather"
DB_DIR="$INSTALL_DIR/db"
SCRIPT="epwtr"
CITIES_FILE="$DB_DIR/cities.txt"
LOG_DIR="/var/log/epweather"
LOG_FILE="$LOG_DIR/epw.log"
SERVICE_FILE="/etc/systemd/system/epweather.service"
TIMER_FILE="/etc/systemd/system/epweather.timer"

if [[ $EUID -ne 0 ]]; then
   echo "run this script with sudo"
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

cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=run epw -u to update weather data

[Service]
ExecStart=/opt/data/epweather/epwtr -u
EOF

cat <<EOF > "$TIMER_FILE"
[Unit]
Description=timer to run epw every 10 minutes

[Timer]
OnBootSec=10min
OnUnitActiveSec=10min
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable epweather.timer
systemctl start epweather.timer

echo "epw installed succussfullt"
echo "try running epw -h"