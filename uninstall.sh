#!/usr/bin/env bash
set -Eeuo pipefail

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run with sudo: sudo ./uninstall.sh" >&2; exit 1; }

keep_config=0
[[ ${1:-} == --keep-config ]] && keep_config=1

systemctl disable --now gre-manager.service rizay-gost.service rizay-private.service \
  rizay-private-keepalive.timer rizay-private-keepalive.service 2>/dev/null || true
if command -v iptables >/dev/null 2>&1; then
  while iptables -w 5 -t nat -C PREROUTING -j GRE_MANAGER_NAT 2>/dev/null; do iptables -w 5 -t nat -D PREROUTING -j GRE_MANAGER_NAT; done
  while iptables -w 5 -C FORWARD -j GRE_MANAGER_FWD 2>/dev/null; do iptables -w 5 -D FORWARD -j GRE_MANAGER_FWD; done
  iptables -w 5 -t nat -F GRE_MANAGER_NAT 2>/dev/null || true
  iptables -w 5 -F GRE_MANAGER_FWD 2>/dev/null || true
  iptables -w 5 -t nat -X GRE_MANAGER_NAT 2>/dev/null || true
  iptables -w 5 -X GRE_MANAGER_FWD 2>/dev/null || true
fi
if command -v ip >/dev/null 2>&1; then
  ip link del gre-manager 2>/dev/null || true
  ip link del rizay-private 2>/dev/null || true
fi
rm -f -- /etc/systemd/system/gre-manager.service /etc/systemd/system/rizay-gost.service \
  /etc/systemd/system/rizay-private.service /etc/systemd/system/rizay-private-keepalive.service \
  /etc/systemd/system/rizay-private-keepalive.timer /usr/local/bin/gre-manager \
  /usr/local/lib/gre-manager/gost /etc/sysctl.d/99-rizay-tunnel.conf
rmdir /usr/local/lib/gre-manager 2>/dev/null || true
systemctl daemon-reload 2>/dev/null || true
if (( keep_config == 0 )); then
  rm -rf -- /etc/gre-manager
  echo "RIZAY Tunnel Manager and its configuration were removed."
else
  echo "RIZAY Tunnel Manager was removed; configuration kept in /etc/gre-manager."
fi
