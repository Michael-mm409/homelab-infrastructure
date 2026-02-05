#!/bin/bash
# Description: Prunes unused Docker resources to maintain system health.
# Path: /infrastructure/scripts/maintenance/docker-cleanup.sh

echo "Starting Docker cleanup at $(date)"
docker system prune -f --volumes
docker image prune -a -f --filter "until=168h" # Remove images older than a week
echo "Cleanup complete."