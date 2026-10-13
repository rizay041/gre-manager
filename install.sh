#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./install.sh" >&2; exit 1; }
[[ $(uname -s) == Linux ]] || { echo "GRE Manager supports Linux only." >&2; exit 1; }
command -v systemctl >/dev/null 2>&1 || { echo "systemd is required." >&2; exit 1; }

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SOURCE="$SCRIPT_DIR/gre-manager"
[[ -f $SOURCE ]] || { echo "gre-manager must be next to install.sh" >&2; exit 1; }

missing=()
for command_name in ip iptables modprobe sysctl awk ping whiptail flock curl tar sha256sum; do
  command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
done
if ((${#missing[@]})); then
  echo "Installing required system packages..."
  if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y iproute2 iptables kmod procps iputils-ping whiptail util-linux curl tar coreutils
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y iproute iptables kmod procps-ng iputils newt util-linux curl tar coreutils
  elif command -v yum >/dev/null 2>&1; then
    yum install -y iproute iptables kmod procps-ng iputils newt util-linux curl tar coreutils
  else
    echo "Missing commands: ${missing[*]}" >&2
    echo "Install iproute2, iptables, kmod, procps, ping, whiptail, curl, tar and coreutils, then retry." >&2
    exit 1
  fi
fi

for command_name in ip iptables modprobe sysctl awk ping whiptail flock curl tar sha256sum; do
  command -v "$command_name" >/dev/null 2>&1 || { echo "Installation failed: $command_name is still missing." >&2; exit 1; }
done

install -d -m 700 /etc/gre-manager
if [[ -f /usr/local/bin/gre-manager ]]; then
  install -d -m 700 /etc/gre-manager/backup
  cp -p /usr/local/bin/gre-manager "/etc/gre-manager/backup/gre-manager.$(date +%Y%m%d%H%M%S)"
fi
install -m 755 "$SOURCE" /usr/local/bin/gre-manager
install -m 644 "$SCRIPT_DIR/gre-manager.service" /etc/systemd/system/gre-manager.service
install -m 644 "$SCRIPT_DIR/rizay-gost.service" /etc/systemd/system/rizay-gost.service
systemctl daemon-reload
systemctl enable gre-manager.service >/dev/null

echo "RIZAY Tunnel Manager installed (GRE + GOST ready)."
echo "Next: sudo gre-manager wizard"
