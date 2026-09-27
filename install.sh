#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./install.sh" >&2; exit 1; }
[[ $(uname -s) == Linux ]] || { echo "GRE Manager supports Linux only." >&2; exit 1; }
command -v systemctl >/dev/null 2>&1 || { echo "systemd is required." >&2; exit 1; }

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SOURCE="$SCRIPT_DIR/gre-manager"
[[ -f $SOURCE ]] || { echo "gre-manager must be next to install.sh" >&2; exit 1; }

missing=()
for command_name in ip iptables modprobe sysctl awk ping; do
  command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
done
if ((${#missing[@]})); then
  echo "Missing commands: ${missing[*]}" >&2
  echo "Debian/Ubuntu: sudo apt install iproute2 iptables kmod procps iputils-ping" >&2
  echo "RHEL/Fedora:   sudo dnf install iproute iptables kmod procps-ng iputils" >&2
  exit 1
fi

install -d -m 700 /etc/gre-manager
install -m 755 "$SOURCE" /usr/local/bin/gre-manager
install -m 644 "$SCRIPT_DIR/gre-manager.service" /etc/systemd/system/gre-manager.service
systemctl daemon-reload
systemctl enable gre-manager.service >/dev/null

echo "GRE Manager installed."
echo "Next: sudo gre-manager configure"
