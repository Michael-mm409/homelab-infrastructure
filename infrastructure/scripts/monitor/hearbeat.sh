#!/bin/bash

# 1. Load Configuration
ENV_FILE="$HOME/scripts/lab_config.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Error: Config file not found at $ENV_FILE"
    exit 1
fi

# 2. Collect System Stats
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)
DISK=$(df -h / | awk 'NR==2 {print $5}')
MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)%

# 3. Send the Green Status Card (Using HEARTBEAT_WEBHOOK from .env)
curl -H "Content-Type: application/json" -X POST -d '{
  "embeds": [{
    "title": "💓 Heartbeat: '"$HOSTNAME"'",
    "description": "System is **Healthy**",
    "color": 3066993,
    "fields": [
      { "name": "Uptime", "value": "'"$UPTIME"'", "inline": false },
      { "name": "CPU Load", "value": "'"$LOAD"'", "inline": true },
      { "name": "Disk Used", "value": "'"$DISK"'", "inline": true },
      { "name": "RAM Used", "value": "'"$MEM"'", "inline": true }
    ],
    "footer": { "text": "Personal Lab Monitoring" },
    "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }]
}' "$HEARTBEAT_WEBHOOK"