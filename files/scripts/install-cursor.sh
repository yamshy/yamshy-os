#!/usr/bin/env bash
set -euo pipefail

echo "Installing Cursor AI Code Editor..."

# Get the latest Cursor RPM download URL
echo "Fetching latest Cursor download URL..."
DOWNLOAD_URL=$(curl -s "https://www.cursor.com/api/download" \
  -H "Accept: application/json" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
  --data-raw '{"platform":"linux-x64","arch":"x64","releaseTrack":"stable","format":"rpm"}' \
  | grep -o '"url":"[^"]*"' | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: Failed to get Cursor download URL"
  exit 1
fi

echo "Download URL: $DOWNLOAD_URL"

# Download and install Cursor
echo "Downloading Cursor RPM..."
curl -L -o /tmp/cursor.rpm "$DOWNLOAD_URL"

echo "Installing Cursor..."
rpm -i /tmp/cursor.rpm

echo "Cleaning up..."
rm -f /tmp/cursor.rpm

echo "Cursor installation completed successfully!"
