# Security Architecture Model

## 🛡️ Layer 1: Perimeter & Ingress
- **Cloudflare Tunnels**: Public services are exposed via outbound-only Argo Tunnels. This removes the need for port-forwarding on the local gateway, mitigating the risk of unsolicited external scans.
- **DDoS Mitigation**: Leveraging Cloudflare's Edge to provide basic WAF and DDoS protection before traffic touches the Proxmox environment.

## 🔑 Layer 2: Access Control (IAM)
- **Identity-Based VPN**: **Tailscale** (WireGuard) provides the management plane. Access to Proxmox, SSH, and internal dashboards is restricted to authorized devices in the "tailnet."
- **Key-Based Auth**: SSH password authentication is globally disabled in favor of **Ed25519** and **RSA-4096** key pairs.

## 📦 Layer 3: Application Security (Marks-Manager)
- **Container Isolation**: Applications are deployed via Docker using non-root users where possible.
- **Secret Management**: API keys and database credentials for the FastAPI backend are managed via `.env` files (excluded from version control) to prevent credential leakage.