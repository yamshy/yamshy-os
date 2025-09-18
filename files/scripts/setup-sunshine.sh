#!/usr/bin/env bash
set -euo pipefail

# Setup script for Sunshine game streaming server
# This script prepares Sunshine configuration for first boot

echo "Setting up Sunshine game streaming server..."

# Create systemd user directory structure
mkdir -p /etc/skel/.config/systemd/user/default.target.wants

# Enable Sunshine service for all new users
ln -sf /usr/lib/systemd/user/sunshine.service /etc/skel/.config/systemd/user/default.target.wants/sunshine.service

# Set capabilities for KMS capture (required for Wayland)
echo "Setting up KMS capture capabilities..."
if command -v sunshine >/dev/null 2>&1; then
    setcap cap_sys_admin+p $(readlink -f $(which sunshine))
else
    echo "Warning: sunshine command not found, skipping setcap"
fi

echo "Sunshine setup completed!"
echo "Service will be enabled for new users on first login"
echo "Web interface will be available at https://localhost:47990 after first boot"
