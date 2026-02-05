#!/bin/bash
# Generate the status and wrap it in basic HTML tags
echo "<html><head><title>VPS Status</title><style>body{background:#121212;color:#00ff00;font-family:monospace;padding:20px;}pre{white-space:pre-wrap;}</style><meta http-equiv='refresh' content='60'></head><body>" > /root/Marks-Manager/src/static/status.html
echo "<h2>System Health Dashboard</h2><pre>" >> /root/Marks-Manager/src/static/status.html
/root/scripts/status_check.sh >> /root/Marks-Manager/src/static/status.html
echo "</pre><p>Last Updated: $(date)</p></body></html>" >> /root/Marks-Manager/src/static/status.html
