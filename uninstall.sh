#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./uninstall.sh" >&2; exit 1; }

if [[ -x /usr/local/bin/gre-manager ]]; then
  if [[ ${1:-} == --keep-config ]]; then
    exec /usr/local/bin/gre-manager uninstall --keep-config
  fi
  exec /usr/local/bin/gre-manager uninstall --purge
fi

systemctl disable --now gre-manager.service rizay-gost.service rizay-private.service \
  rizay-private-keepalive.timer rizay-private-keepalive.service 2>/dev/null || true
rm -f -- /etc/systemd/system/gre-manager.service /etc/systemd/system/rizay-gost.service \
  /etc/systemd/system/rizay-private.service /etc/systemd/system/rizay-private-keepalive.service \
  /etc/systemd/system/rizay-private-keepalive.timer /usr/local/bin/gre-manager \
  /usr/local/lib/gre-manager/gost /etc/sysctl.d/99-rizay-tunnel.conf
rmdir /usr/local/lib/gre-manager 2>/dev/null || true
systemctl daemon-reload 2>/dev/null || true
rm -rf -- /etc/gre-manager
echo "RIZAY Tunnel Manager and its configuration were removed."
