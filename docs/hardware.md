# Hardware Specifications

This document outlines the physical and virtualized hardware supporting the michaelslabs-devsecops infrastructure.

## 🖥 Local Hypervisor (Node 01)
**Device:** GMKtec M5 Plus Mini PC

| Component | Specification |
| :--- | :--- |
| **CPU** | AMD Ryzen 7 5825U (8 Cores, 16 Threads) |
| **RAM** | 32GB DDR4 2666MHz |
| **Storage (OS)** | 2 x 2TB NVMe Gen4 SSD |
| **Hypervisor** | Proxmox VE 8.x |
| **Network** | Dual 2.5GbE RJ45 |

## ☁ Cloud Gateway (Node 02)
**Provider:** BinaryLane (Sydney Region)

| Component | Specification |
| :--- | :--- |
| **CPU** | 1 vCPU (High Performance NVMe Instance) |
| **RAM** | 2GB RAM |
| **Storage** | 40GB NVMe SSD |
| **OS** | Debian 12 (Bookworm) |
| **Public IP** | 112.213.35.50 |

## 🕹 Management Workstation
**Device:** Custom Desktop / Lenovo Ideapad

| Component | Specification |
| :--- | :--- |
| **OS** | Zorin OS Pro (Dual-boot with Windows 11) |
| **Tooling** | VS Code, Git, Tailscale, Docker Desktop |