# Security Policy

## Supported Versions
Only the latest version of the infrastructure and associated services are supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| < 1.1.0 | :x:                |

## Reporting a Vulnerability
As this is a private home lab environment, security vulnerabilities discovered in the infrastructure should be reported via:
- **GitHub Issues**: Please use the "Private Vulnerability Reporting" feature if available.
- **Direct Contact**: mcmillanbmac@gmail.com

## Security Philosophy
This lab follows a **Shift-Left** and **Zero-Trust** philosophy:
- **Shift-Left**: Security is integrated during the initial `docker-compose` and Proxmox LXC setup phase.
- **Zero-Trust**: No internal device is trusted by default; all administrative traffic requires Tailscale authentication and SSH key verification.