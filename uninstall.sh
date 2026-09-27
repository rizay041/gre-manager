#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./uninstall.sh" >&2; exit 1; }
systemctl disable --now gre-manager.service 2>/dev/null || true
/usr/local/bin/gre-manager stop 2>/dev/null || true
rm -f /etc/systemd/system/gre-manager.service /usr/local/bin/gre-manager
systemctl daemon-reload

if [[ ${1:-} == --purge ]]; then
  rm -rf -- /etc/gre-manager
  echo "GRE Manager and its configuration were removed."
else
  echo "GRE Manager removed; configuration kept in /etc/gre-manager."
  echo "Use sudo ./uninstall.sh --purge to remove it too."
fi
