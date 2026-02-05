# Homelab Infrastructure Scripts

This directory contains all automation scripts for the homelab infrastructure, organized by function.

## Directory Structure

```
scripts/
├── monitor/          # System monitoring and health checks
├── sync/             # Data synchronization and backup scripts
├── system/           # System maintenance and failover scripts
├── logs/             # Log files from script executions
├── lab_config.env    # Configuration file with webhook URLs and paths
├── failover.env      # Failover configuration
└── crontab_backup.txt # Current crontab configuration
```

## Script Categories

### Monitor Scripts (`monitor/`)
Scripts for system monitoring and health reporting:
- **heartbeat.sh** - Sends periodic system health reports to Discord
- **status_check.sh** - Checks overall system status
- **heartbeat-old.sh** - Previous version of heartbeat script (archived)

### Sync Scripts (`sync/`)
Data synchronization and backup automation:
- **sync_data.sh** - Synchronizes data to the VPS via rsync and reports status
- **sync_from_home.sh** - Syncs data from home server

### System Scripts (`system/`)
System maintenance and failover operations:
- **migrate_vps.sh** - Handles VPS migration
- **takeover.sh** - Automatic failover script
- **generate_html.sh** - Generates HTML reports
- **failover.env** - Configuration for failover operations

## Configuration

### lab_config.env
Main configuration file containing:
- Discord webhook URLs (backup, critical, heartbeat, access)
- Source/destination paths for syncing
- Log directory paths
- Sync thresholds

### failover.env
Contains failover-specific configuration.

## Cron Jobs

See `crontab_backup.txt` for current scheduled tasks:
- Takeover script runs every 5 minutes
- Heartbeat script runs daily at 9:30 AM

## Logs

All script logs are stored in `logs/` directory:
- `rsync_log.txt` - Data sync operations
- `sync_log.txt` - Sync status
- `failover_log.txt` - Failover operations

## Usage

Scripts are designed to be run via cron jobs. To execute manually:

```bash
bash scripts/monitor/heartbeat.sh
bash scripts/sync/sync_data.sh
bash scripts/system/takeover.sh
```

Ensure `lab_config.env` is properly configured before running sync or monitor scripts.
