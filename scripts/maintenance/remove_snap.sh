#!/usr/bin/env bash
# Script to completely remove snapd and the Discover backend on Fedora

set -e

echo "===> Stopping snapd services..."
sudo systemctl disable --now snapd.socket snapd.service snapd.apparmor.service 2>/dev/null || true

echo "===> Removing snapd RPM packages and Discover plugin..."
sudo dnf remove -y snapd discover-backend-snap

echo "===> Cleaning up residual Snap directories..."
sudo rm -rf /var/lib/snapd /snap ~/snap

echo "===> Process finished successfully. Snap has been completely removed from Fedora."
