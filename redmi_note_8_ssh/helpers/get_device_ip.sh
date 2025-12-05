#!/usr/bin/env bash
# Output only the device's IP address (no error messages)

# Verify a device is connected; exit silently if not
adb get-state 2>/dev/null | grep -q "device" || exit 0

# Attempt to read the IP from the Wi‑Fi interface
ip=$(adb shell "ip -f inet addr show wlan0" 2>/dev/null |
      awk '/inet /{print $2}' | cut -d'/' -f1)

# Fallback: any interface with an IPv4 address
if [[ -z "$ip" ]]; then
    ip=$(adb shell "ip -f inet addr show" 2>/dev/null |
         awk '/inet /{print $2}' | cut -d'/' -f1 | head -n1)
fi

# Older devices may need ifconfig
if [[ -z "$ip" ]]; then
    ip=$(adb shell "ifconfig wlan0" 2>/dev/null |
          awk '/inet addr/{print $2}' | cut -d: -f2)
fi

# Print the IP if found; otherwise exit silently
[[ -n "$ip" ]] && echo "$ip"

