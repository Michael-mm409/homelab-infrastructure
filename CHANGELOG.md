# Changelog

All notable changes to the **michaelslabs-devsecops** infrastructure will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned
- Integration of AdGuard Home as a recursive DNS resolver for the Proxmox environment.
- Implementation of automated Docker image updates via Watchtower.
- Upgrade cloudflared to the latest stable version to address security patches and optimize tunnel performance.
- Refactor .env loading to handle complex strings and add a timeout to the curl command to prevent script hanging during network outages.

## [1.2.0] - 2026-02-05
### Added
- **Disaster Recovery (DR) Logic:** Implemented an automated takeover.sh failover script on the Sydney VPS.
    - Uses `stat` and `find` to monitor data freshness in the `marks-manager` directory.
    - Automates service spin-up if the local Mini PC (pve) heartbeat is lost for > `$SYNC_THRESHOLD`.
- **Cloud Archival:** Configured `rclone` for daily encrypted off-site backups of the university vault and RustDesk configuration to Google Drive.
- **Monitoring Integration:** Added a Discord webhook notification for the failover sequence, providing real-time telemetry on "Last Sync" time during takeover events.
- **Unified Sync & Build Pipeline:** Created a master `sync_from_home.sh` on the VPS to consolidate remote database dumping (via `.11`), code rsync (via `.12`), and Docker image pre-building into a single cron-executed workflow.
- **Cross-Site Database Mirroring:** Configured `pg_dump` to execute over the Tailscale tunnel from the VPS directly to the Postgres node (192.168.3.11), utilizing `.pgpass` for secure, non-interactive authentication.
- **Real-Time Web Dashboard:** Built an automated HTML status generator (`generate_html.sh`) that pipes system telemetry to a CSS-styled "green-screen" dashboard, served via the Marks-Manager Nginx container for mobile/remote monitoring.
- **Pre-emptive Docker Builds:** Integrated `docker compose build --quiet` into the sync pipeline to eliminate failover latency by ensuring images are pre-compiled on the VPS before a disaster occurs.

### Fixed
- **Rsync Recursive Deletion:** Resolved an issue where `--delete` was purging persistent VPS data (like `postgres_data` and the status dashboard) by implementing specific `--exclude` flags in the sync script.
- **Postgres Socket Errors:** Fixed `pg_dump` connection failures by installing `postgresql-client` on the VPS and correctly targeting the remote IP and case-sensitive role names (`Michael`).

### Changed
- **Total Infrastructure Reset:** Performed a factory reinstall of the BinaryLane VPS (Ubuntu 24.04) to clear legacy configuration debt and corrupted database states.
- **Service Decoupling:** Migrated from a combined Docker setup to a more modular architecture, separating rustdesk-server, couchdb, and marks-manager into dedicated stacks for better resource isolation.
### Security
- **Credential Rotation:** Performed a full rotation of SSH host keys and CouchDB administrative credentials following the system reset.
- **SSH Hardening:** Re-enforced Ed25519 key-pair authentication and verified strict file permissions (700 for .ssh, 600 for authorized_keys) to resolve "Permission Denied" handshake errors.

### Fixed
- **Sync Deadlock:** Resolved a "Connection Refused" error in CouchDB by hardcoding the administrative hash in local.ini, bypassing shell-escaping issues with special characters in the initial setup.
- **SSH Identification Conflict:** Rectified the "Remote Host Identification Changed" error on local management consoles by purging stale host fingerprints using ssh-keygen -R.

## [1.1.0] - 2026-02-04
### Added
- **Primary VPS Deployment**: Provisioned a Debian 12 instance on **BinaryLane** (Sydney Region) to serve as a high-availability gateway for personal services.
- **Mesh Networking**: Initialized **Tailscale** on the BinaryLane node to integrate it into the existing private "tailnet," enabling secure cross-site communication without public port exposure.
- **System Observability**: Developed a `heartbeat.sh` monitoring script to provide real-time status telemetry for the Proxmox environment and BinaryLane nodes.

### Changed
- **Environment Migration**: Relocated core workloads from previous hosting to BinaryLane to optimize for NVMe disk I/O and reduced latency for local Australian traffic.
- **Resource Management**: Optimized Zorin OS power profiles on the GMKtec M5 Plus to ensure continuous uptime for Proxmox background services.

### Security
- **Identity & Access Management (IAM)**: Deactivated password-based SSH authentication on the new VPS; enforced **Ed25519 public-key authentication**.
- **Perimeter Hardening**: Configured `sshd_config` to explicitly deny root login, adhering to the principle of least privilege.
- **Zero-Trust Implementation**: Mapped local `/etc/hosts` aliases to Tailscale internal IPs (100.x.x.x) to ensure management traffic never leaves the encrypted tunnel.

### Fixed
- **Application Compatibility**: Resolved a recurring `NullPointerException` in UMLet-standalone by overriding the `-Dsun.java2d.uiScale` property, correcting a high-DPI scaling conflict within the Zorin OS environment.
- **Networking**: Corrected a Docker-to-Host bridge routing conflict that was preventing inter-container communication on the Proxmox internal network.

### Changed
- Migrated primary VPS workloads to high-availability infrastructure in the Sydney region.
- Trialed **Vultr** for a few days; migrated to **BinaryLane** to reduce costs and allow easier resource scaling.
- Optimized SSH configuration to use **Ed25519** elliptic curve signatures.

### Security
- **SSH Hardening**: Disabled password authentication and root login; enforced RSA/Ed25519 key-pair authentication.
- **Network Isolation**: Restricted VPS management access exclusively to the Tailscale private interface (100.x.x.x).

### Fixed
- Resolved `NullPointerException` in UMLet-standalone by overriding Java UI scaling parameters in the environment variables.

## [1.0.0] - 2026-01-10
### Added
- Initial setup of **Proxmox VE** on GMKtec M5 Plus.
- Configured Zorin OS dual-boot workstation as the primary management console.
- Established Git-based documentation workflow for infrastructure tracking.
- **Persistent Ingress Gateway**: Configured a dedicated Debian-based LXC (**Cloudflare-Gateway**) to host the `cloudflared` service.
- **Service Automation**: Implemented `cloudflared` as a `systemd` unit, ensuring the tunnel automatically initializes on container boot and maintains persistent connectivity (Uptime: 4+ days).

### Security
- **Secure Ingress**: Implemented **Cloudflare Tunnels (Argo Tunnel)** to expose internal web services. This architecture eliminates the need for opening inbound ports (80/443) on the home router, significantly reducing the attack surface.
- **Edge Protection**: Leveraged Cloudflare’s edge network for TLS termination and DDoS mitigation before traffic reaches the local Proxmox environment.
- **Tunneling vs. Edge Exposure**: Established an outbound-only tunnel using a secure token, eliminating the need for port-forwarding on the local gateway.
- **Maintenance & Monitoring**: Established a routine for monitoring tunnel health via `systemctl` and the Cloudflare Zero Trust dashboard.