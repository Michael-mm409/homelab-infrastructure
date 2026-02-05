# Infrastructure Automation Scripts

This directory contains all automation scripts for the homelab infrastructure, organized by function.

## Directory Structure

```
infrastructure/scripts/
├── monitor/          # System monitoring and health checks
├── sync/             # Data synchronization and backup scripts
├── system/           # System maintenance and failover scripts
├── backup/           # Backup and archival operations
├── maintenance/      # Routine maintenance tasks
├── security/         # Security scanning and hardening
├── logs/             # Log files from script executions
├── lab_config.env    # Configuration file with webhook URLs and paths
├── crontab_backup.txt # Current crontab configuration
└── README.md         # This file
```

## Script Categories

### Monitor Scripts (`monitor/`)
Scripts for system monitoring and health reporting:
- **heartbeat.sh** - Sends periodic system health reports to Discord with metrics (uptime, CPU load, disk, RAM)
- **status_check.sh** - Checks overall system status and displays interactive dashboard

### Sync Scripts (`sync/`)
Data synchronization and backup automation:
- **sync_data.sh** - Synchronizes data to the VPS via rsync and reports status to Discord
- **sync_from_home.sh** - Master sync from home server including DB dumps, code sync, and Docker pre-builds

### System Scripts (`system/`)
System maintenance and failover operations:
- **migrate_vps.sh** - Handles VPS migration with rclone and streaming archives
- **takeover.sh** - Automatic failover script triggered on heartbeat loss
- **generate_html.sh** - Generates HTML status dashboard
- **failover.env** - Configuration for failover operations

### Backup Scripts (`backup/`)
Backup and archival operations:
- **lab-backup.sh** - Backup automation script

### Maintenance Scripts (`maintenance/`)
Routine maintenance tasks:
- **docker-cleanup.sh** - Prunes unused Docker resources
- **update-tunnel.sh** - Cloudflare tunnel maintenance

### Security Scripts (`security/`)
Security scanning and hardening:
- **trivy-scan.sh** - Vulnerability scanning with Trivy

## Configuration

### lab_config.env
Main configuration file containing:
- Discord webhook URLs (backup, critical, heartbeat, access)
- Source/destination paths for syncing
- Sync thresholds

**⚠️ Security Note:** This file contains sensitive webhook URLs. Ensure it's properly gitignored and not committed to version control.

### failover.env
Contains failover-specific configuration including:
- Project directory paths
- Log file locations
- Discord webhook for failover notifications
- Sync threshold timing

## Cron Jobs

See `crontab_backup.txt` for current scheduled tasks:
- Takeover script runs every 5 minutes (failover watchdog)
- Heartbeat script runs daily at 9:30 AM

## Logs

All script logs are stored in `logs/` directory:
- `rsync_log.txt` - Data sync operations
- `sync_log.txt` - Sync status and timestamps
- `failover_log.txt` - Failover operations and decisions

## Usage

Scripts are designed to be run via cron jobs. To execute manually:

```bash
# Monitor scripts
./monitor/heartbeat.sh
./monitor/status_check.sh

# Sync scripts (usually run from VPS via cron)
./sync/sync_data.sh
./sync/sync_from_home.sh

# System scripts
./system/takeover.sh          # Failover check (runs every 5 min)
./system/migrate_vps.sh       # VPS migration
./system/generate_html.sh     # Generate status HTML
```

## Setup Instructions

1. **Update Configuration Files**
   - Edit `lab_config.env` with your Discord webhook URLs and paths
   - Edit `system/failover.env` with your environment-specific values

2. **Set Executable Permissions**
   ```bash
   chmod +x monitor/*.sh
   chmod +x sync/*.sh
   chmod +x system/*.sh
   chmod +x backup/*.sh
   chmod +x maintenance/*.sh
   chmod +x security/*.sh
   ```

3. **Configure Cron Jobs**
   - Review `crontab_backup.txt` for recommended schedule
   - Add jobs to your crontab: `crontab -e`

4. **Verify Integration**
   - Run `./monitor/status_check.sh` to verify system access
   - Run `./monitor/heartbeat.sh` manually to test Discord notifications

## Security Considerations

- **Webhook URLs** are stored in `lab_config.env` - keep this file private
- **SSH Keys** should be configured for passwordless access to remote servers
- **pgpass** files should be used for database authentication (see sync_from_home.sh)
- All scripts should run with appropriate permissions (non-root when possible)

## Troubleshooting

If scripts aren't running:
1. Check cron logs: `journalctl -u cron`
2. Verify script permissions: `ls -la monitor/heartbeat.sh`
3. Test manually with full paths: `/path/to/infrastructure/scripts/monitor/heartbeat.sh`
4. Check Discord webhooks are accessible
5. Verify configuration files exist and have correct paths
