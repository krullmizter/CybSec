#!/bin/bash
set -euo pipefail

TARGET_IP="192.168.56.102"

echo "Configuring sec-org CTF..."

# Check that sec-org is reachable
if ! ping -c 1 -W 2 "$TARGET_IP" >/dev/null 2>&1; then
    echo "ERROR: sec-org ($TARGET_IP) is not reachable."
    echo "Make sure the sec-org VM is running and connected to the same Host-Only network."
    exit 1
fi

# Remove previous sec-org CTF entries
sed -i '/# sec-org CTF/,/# End sec-org CTF/d' /etc/hosts

# Add CTF hostname mappings
cat >> /etc/hosts <<EOF
# sec-org CTF
$TARGET_IP sec-org.fi
$TARGET_IP www.sec-org.fi
$TARGET_IP intra.sec-org.fi
# End sec-org CTF
EOF

# Verify resolution
echo
echo "Testing hostname resolution..."

if getent hosts sec-org.fi | grep -q "$TARGET_IP"; then
    echo "[OK] sec-org.fi -> $TARGET_IP"
else
    echo "[ERROR] sec-org.fi does not resolve correctly."
    exit 1
fi

if getent hosts intra.sec-org.fi | grep -q "$TARGET_IP"; then
    echo "[OK] intra.sec-org.fi -> $TARGET_IP"
else
    echo "[ERROR] intra.sec-org.fi does not resolve correctly."
    exit 1
fi

echo
echo "sec-org CTF setup complete."
