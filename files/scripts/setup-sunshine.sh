#!/usr/bin/env bash
set -euo pipefail

# Setup script for Sunshine game streaming server
# This script enables and configures the Sunshine service

echo "Setting up Sunshine game streaming server..."

# Enable and start the Sunshine service
systemctl --user enable sunshine
systemctl --user start sunshine

# Set capabilities for KMS capture (required for Wayland)
echo "Setting up KMS capture capabilities..."
setcap cap_sys_admin+p $(readlink -f $(which sunshine))

echo "Sunshine setup completed!"
echo "Web interface will be available at https://localhost:47990"
echo "Service is enabled and started"
