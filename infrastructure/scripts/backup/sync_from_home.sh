#!/bin/bash
# 1. Reach into the Home DB and save a fresh backup directly to the VPS
# (Requires the .pgpass file we discussed on the VPS)
echo "🎬 Starting Remote DB Dump..."
pg_dump -h 192.168.3.11 -U Michael "marks-manager-db" > /root/Marks-Manager/db/latest_backup.sql

# 2. Sync the rest of the application files (Code, Nginx configs, etc.)
echo "📂 Syncing Application Files..."
rsync -avz --delete \
--exclude '.venv/' --exclude '__pycache__/' --exclude '.vscode/' --exclude '*.pyc' \
--exclude 'postgres_data/' --exclude 'src/static/status.html' \
Michael@192.168.3.12:/home/Michael/Marks-Manager/ /root/Marks-Manager/

# 3. Pre-build the images
echo "🛠️ Pre-building Docker Images..."
cd /root/Marks-Manager
docker compose build --quiet

echo "✅ Sync and Pre-build completed at $(date)" >> /root/scripts/logs/sync_log.txt
