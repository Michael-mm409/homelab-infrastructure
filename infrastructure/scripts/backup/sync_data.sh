#!/bin/bash

# 1. IMPORT THE ENV FILE
# This looks for the file and exports every line as a variable
ENV_FILE="$HOME/scripts/lab_config.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Error: Configuration file not found at $ENV_FILE"
    exit 1
fi

# 2. USE THE VARIABLES (Notice how the URLs are now just names)
RESULT=$(/usr/bin/rsync -avz --stats -e "/usr/bin/ssh -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no" "$SOURCE_DIR" "$DEST_SERVER" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    TRANSFERRED=$(echo "$RESULT" | grep "Total transferred file size" | awk -F': ' '{print $2}')
    
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
        "title": "💾 Backup Successful",
        "description": "Data synced to Sydney VPS.",
        "color": 3447003,
        "fields": [{ "name": "Data Sent", "value": "'"$TRANSFERRED"'", "inline": true }]
      }]
    }' "$BACKUP_WEBHOOK"
else
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
        "title": "🚨 CRITICAL: Backup Failure",
        "color": 15158332,
        "description": "Mini PC failed to sync data to VPS!"
      }]
    }' "$CRITICAL_WEBHOOK"
fi

echo "$RESULT" > "$LOG_DIR/rsync_log.txt"
