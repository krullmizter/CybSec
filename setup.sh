#!/usr/bin/env bash
set -euo pipefail

TARGET_IP="192.168.56.102"
LAB_PREFIX="192.168.56."
HOSTNAMES=(sec-org.fi www.sec-org.fi intra.sec-org.fi)
BEGIN="# Sec-Org Environment"
END="# End Sec-Org Environment"

fail() { echo "ERROR: $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || fail "Run this script with sudo: sudo bash setup.sh"

echo "Configuring the Sec-Org lab environment..."

# 1. Kali must have an address on the lab network, and not the target's address
KALI_IPS=$(ip -4 -o addr show | awk '{print $4}' | cut -d/ -f1 | grep -F "$LAB_PREFIX" || true)
if [[ -z "$KALI_IPS" ]]; then
  echo "Current addresses:" >&2
  ip -br -4 addr >&2
  fail "Kali has no ${LAB_PREFIX}x address. Check that Kali's second adapter is Host-only (VirtualBox)
or Host Only (UTM), and that Kali and the target VM run in the same app."
fi
if grep -qxF "$TARGET_IP" <<<"$KALI_IPS"; then
  fail "Kali is using the target's address ($TARGET_IP). Set the host-only DHCP range to start at
${LAB_PREFIX}110 (see the guide), then restart Kali."
fi
echo "[OK] Kali is on the lab network ($(echo $KALI_IPS))."

# 2. Wait for the target VM (ping, or TCP 80/22 in case ICMP is blocked)
is_up() {
  ping -c 1 -W 2 "$TARGET_IP" >/dev/null 2>&1 && return 0
  local port
  for port in 80 22; do
    timeout 2 bash -c "</dev/tcp/$TARGET_IP/$port" 2>/dev/null && return 0
  done
  return 1
}
for attempt in {1..10}; do
  is_up && break
  (( attempt == 10 )) && fail "Target VM ($TARGET_IP) is not reachable. Make sure it has finished
booting (this can take several minutes under UTM) and uses the same host-only network as Kali."
  echo "Waiting for the target VM ($attempt/10)..."
  sleep 3
done
echo "[OK] Target VM is reachable."

# 3. Update /etc/hosts (safe to re-run, with backup)
cp /etc/hosts /etc/hosts.bak
sed -i "/^${BEGIN}\$/,/^${END}\$/d" /etc/hosts
{
  echo "$BEGIN"
  for h in "${HOSTNAMES[@]}"; do echo "$TARGET_IP $h"; done
  echo "$END"
} >> /etc/hosts

for h in "${HOSTNAMES[@]}"; do
  resolved=$(getent hosts "$h" | awk 'NR==1 {print $1}')
  [[ "$resolved" == "$TARGET_IP" ]] || fail "$h resolves to '${resolved:-nothing}', not $TARGET_IP.
Remove any other lines for $h in /etc/hosts (backup: /etc/hosts.bak)."
done
echo "[OK] Hostnames configured."

echo
echo "Environment ready."
