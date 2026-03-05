# homelab-infrastructure

This repository documents a high-performance, local-first private cloud environment designed for data science workloads, secure synchronization, and automated infrastructure management.
## 🎓 Academic Competency Mapping
This infrastructure is architected to exceed the learning outcomes of CSC5090 (Systems Administration) and CSC5520 (Foundations of System Security).

### 🏛️ Pillar 1: Systems Administration & Virtualization (CSC5090)
+ Hypervisor Management: Administration of a Proxmox VE cluster on GMKtec M5 Plus hardware, utilizing Debian 12 LXCs and specialized systemd service persistence.
+ Network Orchestration: Management of complex multi-container stacks using Docker Compose, including health checks, volume persistence, and isolated bridge networks (e.g., proxy-tier).
+ Service Discovery: Implementation of an Nginx Proxy Manager instance to handle SNI-based routing and internal name resolution.

### 🛡️ Pillar 2: System Security & Cloud Ingress (CSC5520 / CSC6711)
+ Zero-Trust Edge Ingress: Utilization of Cloudflare Tunnels (Connector ID: 881608fb...) to expose specific internal services (e.g., University Marks Manager) securely without opening inbound firewall ports.
+ Identity & Access Management (IAM): Enforcement of SSH ed25519 key-pair authentication and Tailscale VPN for all administrative traffic; password-based and root logins are strictly disabled.
+ Secure Containerization: Implementation of multi-stage Docker builds (e.g., Dockerfile.fastapi) to minimize attack surfaces by removing build-time dependencies from the final production image.

## 🛡️ Network Security & Zero-Trust
My security strategy follows a **Zero-Trust** and **Defense-in-Depth** model to secure internal services within a localized environment.

* **Edge Ingress:** I utilize a **Cloudflare Tunnel** (Connector ID: 881608fb...) to expose specific internal services (e.g., University Marks Manager) securely without opening inbound firewall ports.
* **Mechanism:** The tunnel operates within an isolated Proxmox LXC (`Cloudflare-Gateway`) using a secure `cloudflared` service.
* **Management Access:** All administrative traffic is strictly restricted to **Tailscale VPN**, ensuring local services are never exposed to the public internet or direct external scans.

### Key Security Controls
* **Identity & Access:** Enforced **SSH key-pair authentication (ed25519)** with password-based and root logins strictly disabled.
* **Isolation:** Services are segmented using Proxmox LXCs and Docker containers with centralized secret management.
* **Secure Sync:** University files and system backups are synchronized via encrypted Tailscale tunnels to a local Synology NAS.

---

## 🛠 Hardware Stack
This environment is built on a dedicated local "Private Cloud" architecture.

* **Primary Hypervisor:** **GMKtec M5 Plus** running **Proxmox VE**, hosting various Data Science and Security services.
* **Storage Provider:** Centralized **Synology NAS** for persistent data, media, and university archives.
* **Workstations:** Chassis-aware **Fedora** environments (Desktop & Laptop) integrated via a private mesh network.

---

## 📂 Project Structure
* **`automation/fedora-setup/`**: Chassis-aware workstation hardening and sync logic.
    * `setup-fedora.sh`: Master script for hardware detection and baseline security.
    * `hosts/`: Machine-specific logic for **NVIDIA Blackwell** (Desktop) and **Battery Conservation** (Laptop).
* **`infrastructure/scripts/`**: Automated operations, including `uni-archive-sync.sh` for **rclone-based versioned backups**.
* **`docs/`**: Detailed security model and hardware specifications.

---

## 🤖 Systems Automation & IaC
This lab utilizes an **Infrastructure as Code (IaC)** mindset to maintain security baselines across all local nodes.

* **Chassis-Aware Hardening:** Automated detection of hardware types to apply specific optimizations (e.g., 5070-Ti driver injection vs. power tuning).
* **Data Integrity:** Integration of **Mutagen** and **rsync** for real-time synchronization between the Proxmox environment and the Synology NAS.
* **Disaster Recovery:** A versioned archival strategy with a 5-version rotation policy to ensure recovery from local hardware failure or data corruption.
----
## Service Inventory & Security Matrix
| Service             | Role                   | Network Tier          | Security Layer                              |
| ------------------- | ---------------------- | --------------------- | ------------------------------------------- |
| marks-manager-web   | Academic Tracking App  | proxy-tier (Isolated) |No public ports; routed via CF Tunnel.       |
| nginx-proxy-manager | Reverse Proxy / SNI    | proxy-tier (Isolated) | SSL termination; SNI hostname matching.     |
| adguard-home        | Network DNS / Rewrites | Host (LXC)            | Wildcard DNS rewrites for .local TLD.       |
| cloudflare-gateway  | Ingress Tunnel         | Host (LXC)            | Outbound-only tunnel; Zero-Trust edge.      |
| synology-nas        | Persistent Storage     | Management (Mesh)     | Tailscale encrypted tunnels; NFS isolation. |