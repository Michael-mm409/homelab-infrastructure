#!/bin/bash

# 1. Load the environment variables
if [ -f /root/scripts/failover.env ]; then
    export $(grep -v '^#' /root/scripts/failover.env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

# 2. Check if the container is already running
if [ $(docker ps -q -f name=marks-manager | wc -l) -gt 0 ]; then
    exit 0
fi

# 3. Check the Heartbeat
LAST_SYNC=$(stat -c %Y "$PROJECT_DIR")
CURRENT_TIME=$(date +%s)
DIFF=$((CURRENT_TIME - LAST_SYNC))

# 4. Trigger using the variable from the .env file
if [ $DIFF -gt $SYNC_THRESHOLD ]; then
    SYNC_MINUTES=$((DIFF/60))
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
        "title": "🚨 System Failover Initiated",
        "description": "Heartbeat lost. Sydney VPS is taking over.",
        "color": 15158332,
        "fields": [
          { "name": "Last Sync", "value": "'"$SYNC_MINUTES"' minutes ago", "inline": false }
        ],
        "timestamp": "'"$TIMESTAMP"'"
      }]
    }' "$DISCORD_URL"

    echo "$(date): Failover triggered." >> $LOG_FILE
    cd $PROJECT_DIR
    /usr/bin/docker compose up -d >> $LOG_FILE 2>&1
fi
