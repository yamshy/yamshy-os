#!/usr/bin/env bash
set -euo pipefail

echo "Installing Cursor AI Code Editor..."

# Use the specific URL you provided as it's known to work
# This may need periodic updates when new versions are released
DOWNLOAD_URL="https://downloads.cursor.com/production/6af2d906e8ca91654dd7c4224a73ef17900ad735/linux/x64/rpm/x86_64/cursor-1.6.26.el8.x86_64.rpm"

echo "Using download URL: $DOWNLOAD_URL"

# Download and install Cursor
echo "Downloading Cursor RPM..."
if ! curl -L -f -o /tmp/cursor.rpm "$DOWNLOAD_URL"; then
  echo "Error: Failed to download Cursor from $DOWNLOAD_URL"
  echo "The download URL may be outdated. Please check https://cursor.com/downloads for the latest RPM URL"
  exit 1
fi

echo "Installing Cursor..."
rpm -i /tmp/cursor.rpm

echo "Cleaning up..."
rm -f /tmp/cursor.rpm

echo "Cursor installation completed successfully!"