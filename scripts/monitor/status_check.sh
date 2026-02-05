#!/bin/bash
echo "=========================================="
echo "   🚀 SYDNEY GATEWAY HEALTH DASHBOARD"
echo "=========================================="
echo "DATE: $(date)"
echo "------------------------------------------"

# 1. Check Docker Containers
echo -e "📦 DOCKER STATUS:"
docker ps --format "table {{.Names}}\t{{.Status}}" | sed 's/^/  /'

# 2. Check Tailscale Bridge
echo -e "\n🌐 TAILSCALE BRIDGE:"
PVE_STATUS=$(tailscale status | grep "pve" | awk '{print $4}')
LXC_STATUS=$(ping -c 1 -W 1 192.168.3.12 > /dev/null && echo "ONLINE" || echo "OFFLINE")
echo "  Mini PC (pve):  $PVE_STATUS"
echo "  Docker LXC:     $LXC_STATUS"

# 3. Check Last Syncs
echo -e "\n🔄 RECENT SYNCS:"
LAST_SYNC=$(tail -n 1 /root/scripts/logs/sync_log.txt 2>/dev/null || echo "No sync log found")
echo "  Home Mirror:  $LAST_SYNC"

# 4. Failover Status
echo -e "\n🛡️ FAILOVER WATCHDOG:"
LAST_HB=$(tail -n 1 /root/scripts/logs/failover_log.txt 2>/dev/null || echo "No heartbeat log found")
echo "  Last Check:   $LAST_HB"
echo "=========================================="
