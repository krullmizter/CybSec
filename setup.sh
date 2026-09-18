#!/bin/bash
set -euo pipefail

TARGET_IP="192.168.56.102"

echo "Configuring CTF environment..."

# Check that the target VM is reachable
if ! ping -c 1 -W 2 "$TARGET_IP" >/dev/null 2>&1; then
    echo "ERROR: Target VM ($TARGET_IP) is not reachable."
    echo "Make sure the target VM is running and connected to the same Host-Only network."
    exit 1
fi

# Remove previous CTF entries
sed -i '/# Sec-Org Environment/,/# End Sec-Org Environment/d' /etc/hosts

# Add hostname mappings
cat >> /etc/hosts <<EOF
# Sec-Org Environment
$TARGET_IP sec-org.fi
$TARGET_IP www.sec-org.fi
$TARGET_IP intra.sec-org.fi
# End Sec-Org Environment
EOF

# Verify resolution
echo
echo "Testing network configuration..."

if getent hosts sec-org.fi | grep -q "$TARGET_IP"; then
    :
else
    echo "ERROR: Target hostname configuration failed."
    exit 1
fi

if getent hosts www.sec-org.fi | grep -q "$TARGET_IP"; then
    :
else
    echo "ERROR: Target hostname configuration failed."
    exit 1
fi

if getent hosts intra.sec-org.fi | grep -q "$TARGET_IP"; then
    :
else
    echo "ERROR: Target hostname configuration failed."
    exit 1
fi

echo "[OK] Target VM is reachable."
echo "[OK] Network configuration verified."
echo
echo "CTF environment ready."

