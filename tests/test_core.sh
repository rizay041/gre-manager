#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=../gre-manager
# shellcheck disable=SC1091
source "$ROOT_DIR/gre-manager"

tests=0
failures=0

check() {
  local name=$1
  shift
  ((tests+=1))
  if "$@"; then
    printf 'ok %d - %s\n' "$tests" "$name"
  else
    printf 'not ok %d - %s\n' "$tests" "$name"
    ((failures+=1))
  fi
}

is_equal() { [[ $1 == "$2" ]]; }
is_not_valid_ipv4() { ! valid_ipv4 "$1"; }
is_not_valid_port() { ! valid_port "$1"; }
is_not_valid_mode() { ! valid_mode "$1"; }
is_not_valid_transport() { ! valid_transport "$1"; }

check "accept normal IPv4" valid_ipv4 "203.0.113.10"
check "accept IPv4 boundaries" valid_ipv4 "0.0.0.0"
check "reject IPv4 octet overflow" is_not_valid_ipv4 "203.0.113.999"
check "reject IPv4 shell input" is_not_valid_ipv4 '1.2.3.4;id'
check "accept first TCP port" valid_port "1"
check "accept last TCP port" valid_port "65535"
check "reject zero port" is_not_valid_port "0"
check "reject port overflow" is_not_valid_port "65536"
check "accept minimum health samples" valid_samples "5"
check "accept maximum health samples" valid_samples "200"
check "accept HYBRID mode" valid_mode "hybrid"
check "accept GRE mode" valid_mode "gre"
check "accept GOST mode" valid_mode "gost"
check "reject unknown mode" is_not_valid_mode "wireguard"
check "accept public GOST path" valid_transport "public"
check "accept GRE GOST path" valid_transport "gre"
check "reject unsafe GOST path" is_not_valid_transport 'public;id'

export ROLE="iran"
export MODE="hybrid"
export IRAN_IP="203.0.113.10"
export KHAREJ_IP="198.51.100.20"
export MTU="1400"
validate_config
check "IRAN local endpoint" is_equal "$LOCAL_IP" "$IRAN_IP"
check "IRAN remote endpoint" is_equal "$REMOTE_IP" "$KHAREJ_IP"
check "IRAN GRE address" is_equal "$GRE_LOCAL" "10.77.0.1"
check "IRAN GRE peer" is_equal "$GRE_REMOTE" "10.77.0.2"

export ROLE="kharej"
validate_config
check "KHAREJ local endpoint" is_equal "$LOCAL_IP" "$KHAREJ_IP"
check "KHAREJ remote endpoint" is_equal "$REMOTE_IP" "$IRAN_IP"
check "KHAREJ GRE address" is_equal "$GRE_LOCAL" "10.77.0.2"
check "KHAREJ GRE peer" is_equal "$GRE_REMOTE" "10.77.0.1"

printf '1..%d\n' "$tests"
(( failures == 0 ))
