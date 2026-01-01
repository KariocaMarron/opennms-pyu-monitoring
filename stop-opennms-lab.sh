#!/bin/bash
echo "Stopping OpenNMS PYU Lab..."

cd ~/pyu-opennms_lab/fog && docker compose down
cd ~/pyu-opennms_lab/dns-dhcp && docker compose down
cd ~/pyu-opennms_lab/semaphore && docker compose down
cd ~/pyu-opennms_lab/ldap && docker compose down
cd ~/pyu-opennms_lab/minions/chongjin && docker compose down
cd ~/pyu-opennms_lab/minions/hamhung && docker compose down
docker stop pyu-py-router pyu-py-switch 2>/dev/null
cd ~/pyu-opennms_lab/horizon && docker compose down

echo "Lab stopped. Data preserved in Docker volumes."

# Jose Vasconcelos - Jan 2026
# GitHub - KariocaMarron
# COM615 Network Management - Pyongyang University OpenNMS Lab
