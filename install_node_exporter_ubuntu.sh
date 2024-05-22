#!/bin/bash


################################################################################
# Description:                                                              
#   This script automates the installation and configuration of Node Exporter,
#   a Prometheus exporter for hardware and OS metrics exposed by *NIX kernels.
#
#   For more information about Node Exporter, visit:
#   https://github.com/prometheus/node_exporter
#
# Usage:
#   Run this script with superuser privileges. It will perform the necessary
#   steps to install Node Exporter on your system.
#
# Note:
#   - Review the script to understand the actions it performs before running it.
#
# Author: @joshi101
################################################################################


# Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz

# Unzip and move to /usr/local/bin
tar -xvf node_exporter-1.8.0.linux-amd64.tar.gz
cd node_exporter-1.8.0.linux-amd64/
cp node_exporter /usr/local/bin

# Create user
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create service file
tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Update system daemon
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
