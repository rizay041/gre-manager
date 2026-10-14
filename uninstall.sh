#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./uninstall.sh" >&2; exit 1; }
systemctl disable --now gre-manager.service 2>/dev/null || true
systemctl disable --now rizay-gost.service 2>/dev/null || true
systemctl disable --now rizay-private-keepalive.timer rizay-private.service 2>/dev/null || true
/usr/local/bin/gre-manager stop-gre 2>/dev/null || true
/usr/local/bin/gre-manager stop-private 2>/dev/null || true
rm -f /etc/systemd/system/gre-manager.service /etc/systemd/system/rizay-gost.service /usr/local/bin/gre-manager
rm -f /etc/systemd/system/rizay-private.service /etc/systemd/system/rizay-private-keepalive.service /etc/systemd/system/rizay-private-keepalive.timer
rm -f /usr/local/lib/gre-manager/gost
rmdir /usr/local/lib/gre-manager 2>/dev/null || true
systemctl daemon-reload

if [[ ${1:-} == --purge ]]; then
  rm -rf -- /etc/gre-manager
  rm -f -- /etc/sysctl.d/99-rizay-tunnel.conf
  echo "RIZAY Tunnel Manager and its configuration were removed."
else
  echo "RIZAY Tunnel Manager removed; configuration kept in /etc/gre-manager."
  echo "Use sudo ./uninstall.sh --purge to remove it too."
fi
