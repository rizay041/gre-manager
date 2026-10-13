#!/usr/bin/env bash
set -Eeuo pipefail
exec 8>&2

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TEST_DIR=$(mktemp -d)
cleanup() {
  local status=$?
  if (( status != 0 )) && [[ -f $TEST_DIR/output ]]; then cat "$TEST_DIR/output" >&8; fi
  rm -rf -- "$TEST_DIR"
}
trap cleanup EXIT
export GRE_MANAGER_CONFIG_DIR="$TEST_DIR/config"
export GRE_MANAGER_UI=terminal
# shellcheck source=../gre-manager
# shellcheck disable=SC1091
source "$ROOT_DIR/gre-manager"

CALLS="$TEST_DIR/calls"
OUTPUT="$TEST_DIR/output"
tests=0
failures=0

# Only host/network mutations are mocked. Inputs, validation, saved config,
# batch migration and the generated GOST YAML use production functions.
require_root() { :; }
clear() { :; }
banner() { :; }
acquire_lock() { LOCK_HELD=1; }
release_lock() { LOCK_HELD=0; }
install_gost_binary() { printf 'gost-install\n' >> "$CALLS"; }
systemctl() {
  if [[ ${1:-} == restart && ${2:-} == gre-manager.service && $LOCK_HELD == 1 ]]; then
    printf 'ERROR: GRE service restarted while the configuration lock was held\n' >&2
    return 1
  fi
  printf 'systemctl %s\n' "$*" >> "$CALLS"
}

# Git Bash cannot apply POSIX permissions on Windows. Linux CI uses real
# install/chmod; local Windows runs still exercise the real saved-file logic.
if [[ $(uname -s) == MINGW* ]]; then
  install() {
    if [[ ${1:-} == -d && ${2:-} == -m ]]; then mkdir -p -- "${@:4}";
    else command install "$@"; fi
  }
  chmod() { :; }
fi

check() {
  local name=$1
  shift
  ((tests+=1))
  if "$@"; then printf 'ok %d - %s\n' "$tests" "$name";
  else printf 'not ok %d - %s\n' "$tests" "$name"; ((failures+=1)); fi
}

equals() { [[ $1 == "$2" ]]; }
has_lines() { [[ $(wc -l < "$1" | tr -d '[:space:]') == "$2" ]]; }
absent() { [[ ! -e $1 ]]; }
reset_state() {
  rm -f -- "$CONFIG_FILE" "$RULES_FILE" "$GOST_RULES_FILE" "$GOST_CONFIG_FILE" "$CALLS" "$OUTPUT"
  export ROLE="" MODE=hybrid IRAN_IP="" KHAREJ_IP="" MTU=1400
}

reset_state
wizard <<< $'1\n203.0.113.10\n198.51.100.20\n443,8443,2053\n1\n1\n1' > "$OUTPUT" 2>&1
check "IRAN menu installs three ports without commands" has_lines "$GOST_RULES_FILE" 3
check "wizard saves IRAN profile" grep -Fxq ROLE=iran "$CONFIG_FILE"
check "wizard keeps GRE alongside GOST" grep -Fxq MODE=hybrid "$CONFIG_FILE"
check "public GOST rule maps the same port" grep -Fxq 'tcp 8443 8443 public' "$GOST_RULES_FILE"
check "public GOST targets the KHAREJ IP" grep -Fq '198.51.100.20:8443' "$GOST_CONFIG_FILE"
check "GRE is started automatically" grep -Fxq 'systemctl restart gre-manager.service' "$CALLS"
check "GOST is started automatically" grep -Fxq 'systemctl restart rizay-gost.service' "$CALLS"
check "setup releases its mutation lock" equals "$LOCK_HELD" 0

reset_state
wizard iran <<< $'203.0.113.10\n198.51.100.20\n443,2053\n3\n2\n1' > "$OUTPUT" 2>&1
check "TCP plus UDP creates four rules" has_lines "$GOST_RULES_FILE" 4
check "UDP is included" grep -Fxq 'udp 2053 2053 gre' "$GOST_RULES_FILE"
check "GOST inside GRE targets the private peer" grep -Fq '10.77.0.2:2053' "$GOST_CONFIG_FILE"

reset_state
wizard iran <<< $'203.0.113.10\n198.51.100.20\n443,2053\n2\n3\n1' > "$OUTPUT" 2>&1
check "GRE option saves two iptables rules" has_lines "$RULES_FILE" 2
check "GRE option saves UDP protocol" grep -Fxq 'udp 443 443' "$RULES_FILE"
check "GRE option does not create GOST rules" absent "$GOST_RULES_FILE"

reset_state
wizard <<< $'2\n203.0.113.10\n198.51.100.20\n1' > "$OUTPUT" 2>&1
check "KHAREJ option configures the destination" grep -Fxq ROLE=kharej "$CONFIG_FILE"
check "KHAREJ does not request or create forwarding ports" absent "$GOST_RULES_FILE"
check "KHAREJ starts GRE" grep -Fxq 'systemctl restart gre-manager.service' "$CALLS"

reset_state
wizard iran <<< $'203.0.113.10\n198.51.100.20\n443,8443\n1\n1\n0' > "$OUTPUT" 2>&1
check "cancel does not write configuration" absent "$CONFIG_FILE"
check "cancel does not download GOST or start services" absent "$CALLS"

reset_state
wizard iran <<< $'203.0.113.10\n198.51.100.20\n443,,8443\n443,8443\n1\n1\n1' > "$OUTPUT" 2>&1
check "invalid comma input is reported" grep -Fq 'Enter ports separated by commas' "$OUTPUT"
check "valid retry creates both ports" has_lines "$GOST_RULES_FILE" 2

add_ports_wizard <<< $'2053,2087\n\n3\n1\n1' > "$OUTPUT" 2>&1
check "Add Ports handles comma lists and keeps old rules" has_lines "$GOST_RULES_FILE" 6
check "new UDP rule is active in saved config" grep -Fxq 'udp 2087 2087 public' "$GOST_RULES_FILE"

add_ports_wizard <<< $'443,8443\n9443,10443\n1\n3\n1' > "$OUTPUT" 2>&1
check "destination ports map in the entered order" grep -Fxq 'tcp 8443 10443' "$RULES_FILE"
check "engine migration removes only selected GOST pairs" has_lines "$GOST_RULES_FILE" 4
check "engine migration keeps other TCP ports" grep -Fxq 'tcp 2053 2053 public' "$GOST_RULES_FILE"

before=$(sha256sum "$RULES_FILE" "$GOST_RULES_FILE")
if (save_port_batch gost tcp '443,0' '443,8443') >/dev/null 2>&1; then
  check "invalid batch must fail" equals accepted rejected
fi
after=$(sha256sum "$RULES_FILE" "$GOST_RULES_FILE")
check "invalid batch leaves saved files unchanged" equals "$before" "$after"

reset_state
menu <<< $'1\n203.0.113.10\n198.51.100.20\n443,8443\n1\n1\n1\n0' > "$OUTPUT" 2>&1
check "main panel offers numeric IRAN setup" grep -Fq '1) IRAN - setup IPs' "$OUTPUT"
check "complete main-panel flow saves both ports" has_lines "$GOST_RULES_FILE" 2

reset_state
menu <<< $'4\n0' > "$OUTPUT" 2>&1
check "unconfigured status returns to the menu" grep -Fq 'Setup first' "$OUTPUT"
check "unconfigured status does not create config" absent "$CONFIG_FILE"

printf '1..%d\n' "$tests"
(( failures == 0 ))
