#!/bin/bash

# Configuration (You can put these in your .env later)
WEBHOOK_URL="https://discordapp.com/api/webhooks/1467304064252510209/hIlGrkQ8wnKPcojaGnPvocad5vs7-T-QfYypOjRKEczZocPI1aPzRujkL_e6zWtK_2Of"
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

# Create a clean message
MESSAGE="💓 **Heartbeat from $HOSTNAME**: System is UP ($UPTIME)"

# Send to Discord
curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
