#!/bin/bash
echo "Starting OpenNMS PYU Lab..."
echo "Estimated time: ~5 minutes"
echo ""

# 1. Core infrastructure (PostgreSQL must be healthy before OpenNMS)
echo "[1/7] Starting core infrastructure (PostgreSQL, ActiveMQ, OpenNMS)..."
cd ~/pyu-opennms_lab/horizon && docker compose up -d
echo "Waiting 120s for PostgreSQL + OpenNMS to initialize..."
sleep 120

# 2. Start Minions (need OpenNMS + ActiveMQ ready)
echo "[2/7] Starting Minions..."
cd ~/pyu-opennms_lab/minions/hamhung && docker compose up -d
sleep 5
cd ~/pyu-opennms_lab/minions/chongjin && docker compose up -d
sleep 5

# 3-6. Start independent services (can run in parallel with Minion registration)
echo "[3/7] Starting LDAP..."
cd ~/pyu-opennms_lab/ldap && docker compose up -d
sleep 5

echo "[4/7] Starting DNS/DHCP..."
cd ~/pyu-opennms_lab/dns-dhcp && docker compose up -d
sleep 5

echo "[5/7] Starting Semaphore..."
cd ~/pyu-opennms_lab/semaphore && docker compose up -d
sleep 5

echo "[6/7] Starting FOG Server..."
cd ~/pyu-opennms_lab/fog && docker compose up -d
sleep 5

# 7. Network devices
echo "[7/7] Starting network devices..."
docker start pyu-py-router pyu-py-switch 2>/dev/null

# Final wait for everything to stabilize
echo "Waiting 60s for all services to stabilize..."
sleep 60

# Health check
echo ""
echo "=== Final Health Check ==="
curl -s -o /dev/null -w "OpenNMS: HTTP %{http_code}\n" http://localhost:8980/opennms/login.jsp
curl -s -u admin:admin "http://localhost:8980/opennms/rest/nodes?limit=0" | grep -o 'totalCount="[0-9]*"' | sed 's/totalCount="/Nodes: /;s/"$//'
docker ps --format "{{.Names}}" | grep minion | while read m; do echo "Minion: $m ✓"; done
echo ""
echo "Container count: $(docker ps -q | wc -l)"
echo ""
echo "Lab ready! Access: http://localhost:8980/opennms (admin/admin)"

# Jose Vasconcelos - Jan 2026
# GitHub - KariocaMarron
# COM615 Network Management - Pyongyang University OpenNMS Lab
