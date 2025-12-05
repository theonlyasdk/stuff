#!/usr/bin/env bash
set -euo pipefail   # stop on errors, treat unset vars as errors

# -------------------------------------------------
# 1️⃣  Put the device into TCP/IP mode (port 5555)
# -------------------------------------------------
echo "🔧 Enabling ADB over Wi‑Fi (port 5555)…"
adb tcpip 5555

# -------------------------------------------------
# 2️⃣  Get the device’s IP address
# -------------------------------------------------
# helpers/get_device_ip.sh should output only the IPv4 address.
# If it fails, abort with a clear message.
if ! IP=$(bash helpers/get_device_ip.sh); then
    echo "❌ Failed to obtain device IP. Check helpers/get_device_ip.sh"
    exit 1
fi

# Trim possible whitespace/newlines
IP=$(echo "$IP" | tr -d '[:space:]')
echo "📡 Device IP: $IP"

# -------------------------------------------------
# 3️⃣  Connect to the device wirelessly
# -------------------------------------------------
echo "🔗 Connecting to $IP:5555…"
adb connect "${IP}:5555"

# -------------------------------------------------
# 4️⃣  Set up port forwards (optional but common)
# -------------------------------------------------
for port in 8022 5901; do
    echo "🔀 Forwarding localhost:${port} → ${IP}:${port}"
    adb forward "tcp:${port}" "tcp:${port}"
done

# -------------------------------------------------
# 5️⃣  Open an SSH session (if you have an SSH server on the device)
# -------------------------------------------------
echo "🖥️  Opening SSH to localhost on port 8022…"
ssh -p 8022 localhost

