# === monitoring/check_node_exporter.sh ===
#!/bin/bash
IP=$(cat ../ansible/hosts_ip.txt)
echo "Checking Node Exporter at $IP:9100..."
curl -s http://$IP:9100/metrics | grep "node_cpu_seconds_total" && echo "Monitoring Active" || echo "Node Exporter not reachable"
