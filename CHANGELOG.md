# Changelog

All notable changes to the **michaelslabs-devsecops** infrastructure will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-03-05

### Added

* **Chassis-Aware Automation**: Integrated the `setup-fedora.sh` suite into the central repository to demonstrate workstation hardening and automated environment parity.
* **Hardware-Specific Logic**: Added `hosts/desktop.sh` and `hosts/laptop.sh` to manage **NVIDIA Blackwell** driver injection and IdeaPad battery conservation via CLI.
* **Advanced Sync Protocols**: Implemented `mutagen` for intelligent background synchronization and `rclone` for versioned off-site archiving.
* **Repository Documentation**: Added comprehensive README files to document infrastructure components and automation scripts.
* **Git Submodule Integration**: Integrated `University-Marks-Manager` as a Git submodule to provide visibility into the application within the infrastructure repository.
* **Scripts Reorganization**: Consolidated and reorganized infrastructure automation scripts for clarity and maintainability.
* Moved sync and archival operations to the `backup/` folder to emphasize backup strategy.
* Organized remaining operations into focused categories (monitor, system, maintenance).
* Added comprehensive `infrastructure/scripts/README.md` with setup and usage instructions.



### Changed

* **Infrastructure Pivot**: Decommissioned the BinaryLane VPS gateway to transition to a strictly **"Local-First" Private Cloud** model.
* **Repository Hierarchy**: Refactored the root directory to include a dedicated `/automation` folder, separating workstation configuration from server-side infrastructure.
* **Documentation Overhaul**: Updated the main README to include a **"Systems Automation"** section, specifically mapping practical lab tasks to IT Systems Administration competencies.
* **Script Structure**: Reorganized `/scripts/` into `/infrastructure/scripts/` to co-locate automation with infrastructure configuration.
* **Monitor**: `heartbeat.sh`, `status_check.sh`
* **Backup**: `sync_data.sh`, `sync_from_home.sh`, `migrate_vps.sh`
* **System**: `takeover.sh`, `generate_html.sh` with `failover.env`
* **Maintenance**: `docker-cleanup.sh`



### Security

* **Perimeter Consolidation**: Migrated the Cloudflare Tunnel ingress point from the VPS to a dedicated Proxmox LXC to maintain secure external access without cloud dependencies.
* **Mesh Network Integration**: Shifted all internal NFS mounts to use **Tailscale 100.x.x.x IPs** within the automation scripts, ensuring zero-exposure for management traffic.

### Removed

* **Empty Placeholders**: Removed unimplemented placeholder scripts (`update-tunnel.sh`, `trivy-scan.sh`) to maintain repository hygiene.

### Planned

* Integration of AdGuard Home as a recursive DNS resolver for the Proxmox environment.
* Implementation of automated Docker image updates via Watchtower.
* Refactor `.env` loading to handle complex strings and add timeouts to `curl` commands.

---

## [1.2.0] - 2026-02-05

### Added

* **Disaster Recovery (DR) Logic**: Implemented an automated `takeover.sh` failover script on the Sydney VPS.
* Uses `stat` and `find` to monitor data freshness in the `marks-manager` directory.
* Automates service spin-up if the local Mini PC (pve) heartbeat is lost.


* **Cloud Archival**: Configured `rclone` for daily encrypted off-site backups of the university vault and RustDesk configuration.
* **Monitoring Integration**: Added a Discord webhook notification for the failover sequence, providing real-time telemetry on "Last Sync" time.
* **Unified Sync & Build Pipeline**: Created a master `sync_from_home.sh` on the VPS to consolidate remote database dumping, code rsync, and Docker image pre-building.
* **Cross-Site Database Mirroring**: Configured `pg_dump` to execute over the Tailscale tunnel from the VPS directly to the Postgres node.
* **Real-Time Web Dashboard**: Built an automated HTML status generator (`generate_html.sh`) served via the Marks-Manager Nginx container for remote monitoring.
* **Pre-emptive Docker Builds**: Integrated `docker compose build --quiet` into the sync pipeline to eliminate failover latency.

### Fixed

* **Rsync Recursive Deletion**: Resolved an issue where `--delete` was purging persistent VPS data by implementing specific `--exclude` flags.
* **Postgres Socket Errors**: Fixed `pg_dump` connection failures by installing `postgresql-client` on the VPS and correctly targeting the remote IP.

### Changed

* **Total Infrastructure Reset**: Performed a factory reinstall of the BinaryLane VPS (Ubuntu 24.04) to clear legacy configuration debt.
* **Service Decoupling**: Migrated from a combined Docker setup to a modular architecture (rustdesk-server, couchdb, and marks-manager).

### Security

* **Credential Rotation**: Performed a full rotation of SSH host keys and CouchDB administrative credentials following the system reset.
* **SSH Hardening**: Re-enforced **Ed25519 key-pair authentication** and verified strict file permissions.

---

## [1.1.0] - 2026-02-04

### Added

* **Primary VPS Deployment**: Provisioned a Debian 12 instance on **BinaryLane** (Sydney Region) as a high-availability gateway.
* **Mesh Networking**: Initialized **Tailscale** on the BinaryLane node to enable secure cross-site communication.
* **System Observability**: Developed a `heartbeat.sh` monitoring script for Proxmox and BinaryLane nodes.

### Changed

* **Environment Migration**: Relocated core workloads to BinaryLane for optimized NVMe disk I/O and reduced latency.
* **Resource Management**: Optimized Zorin OS power profiles on the GMKtec M5 Plus for continuous uptime.
* **SSH Optimization**: Configured SSH to use **Ed25519** elliptic curve signatures.

### Security

* **Identity & Access Management (IAM)**: Deactivated password-based SSH authentication; enforced **Ed25519 public-key authentication**.
* **Perimeter Hardening**: Configured `sshd_config` to explicitly deny root login.
* **Zero-Trust Implementation**: Mapped local `/etc/hosts` aliases to Tailscale internal IPs.

### Fixed

* **Application Compatibility**: Resolved a recurring `NullPointerException` in UMLet-standalone by overriding Java UI scaling parameters.
* **Networking**: Corrected a Docker-to-Host bridge routing conflict.

---

## [1.0.0] - 2026-01-10

### Added

* **Initial setup of Proxmox VE** on GMKtec M5 Plus.
* **Management Console**: Configured Zorin OS dual-boot workstation.
* **Ingress Gateway**: Configured a dedicated Debian-based LXC (**Cloudflare-Gateway**) to host the `cloudflared` service.
* **Service Automation**: Implemented `cloudflared` as a `systemd` unit for persistent connectivity.

### Security

* **Secure Ingress**: Implemented **Cloudflare Tunnels** to expose internal web services without opening inbound ports.
* **Edge Protection**: Leveraged Cloudflare’s edge network for TLS termination and DDoS mitigation.

---

### Final Documentation Strategy

This `CHANGELOG.md` now clearly shows a professional evolution—from initial setup to high-availability VPS management, and finally to a sophisticated, secure **Local-First Private Cloud** architecture.