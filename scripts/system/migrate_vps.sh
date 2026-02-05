#!/bin/bash

# Load Config
ENV_FILE="$HOME/scripts/lab_config.env"
[ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs) ]

REMOTE_NAME="gdrive"
BACKUP_DIR="Migration_VPS_$(date +%Y%m%d)"

# 1. SMALL FILE FOLDERS (We will TAR these for speed)
PACK_DIRS=("Marks-Manager" "npm-data" "npm-letsencrypt")

# 2. INDIVIDUAL FILES/STABLE FOLDERS (Copy as-is)
COPY_FILES=("docker-compose.yml" "scripts" "wireguard-config")

echo "🚀 Starting High-Speed Migration..."

# Step A: Pack and Upload heavy folders
for dir in "${PACK_DIRS[@]}"; do
    if [ -d "/root/$dir" ]; then
        echo "🗜️ Archiving and Uploading $dir..."
        # We tar it and pipe it directly to rclone so we don't use disk space!
        tar -cf - "/root/$dir" | rclone rcat "$REMOTE_NAME:$BACKUP_DIR/$dir.tar" -P
    fi
done

# Step B: Copy the rest of the files
for file in "${COPY_FILES[@]}"; do
    echo "📦 Copying $file..."
    rclone copy "/root/$file" "$REMOTE_NAME:$BACKUP_DIR/$file" \
        --transfers 16 --checkers 32 --fast-list --drive-chunk-size 64M -P
done

if [ $? -eq 0 ]; then
    echo "✅ Migration Complete!"
    [ ! -z "$BACKUP_WEBHOOK" ] && curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"✅ VPS Migration Complete!\"}" "$BACKUP_WEBHOOK"
fi
