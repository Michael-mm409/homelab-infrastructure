# Infrastructure Implementation Notes

## Proxmox LXC Config
- **Cloudflare-Gateway (ID 100)**: Debian 12. Using `systemd` to keep `cloudflared` alive.
- **Resource Allocation**: 512MB RAM is sufficient for the tunnel gateway; monitoring peak usage at 30MB.

## Marks-Manager Deployment
- **Dockerfile.fastapi**: Multi-stage build to reduce image size and attack surface (removing build-time dependencies from the final image).
- **Network**: Using a dedicated Docker bridge network to isolate the frontend from the backend database.