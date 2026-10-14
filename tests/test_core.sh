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
is_not_valid_port_list() { ! parse_port_list "$1"; }
has_port_list() { parse_port_list "$1" && [[ $PORT_LIST == "$2" ]]; }
has_batch_size() { prepare_port_batch "$1" "$2" "$3" && [[ ${#BATCH_SOURCES[@]} == "$4" && ${#BATCH_PROTOCOLS[@]} == "$5" ]]; }
has_no_valid_batch() { ! prepare_port_batch "$1" "$2" "$3"; }

check "accept normal IPv4" valid_ipv4 "203.0.113.10"
check "accept IPv4 boundaries" valid_ipv4 "0.0.0.0"
check "reject IPv4 octet overflow" is_not_valid_ipv4 "203.0.113.999"
check "reject IPv4 shell input" is_not_valid_ipv4 '1.2.3.4;id'
check "accept first TCP port" valid_port "1"
check "accept last TCP port" valid_port "65535"
check "reject zero port" is_not_valid_port "0"
check "reject port overflow" is_not_valid_port "65536"
check "reject arithmetic overflow" is_not_valid_port "18446744073709551617"
check "normalize comma-separated ports" has_port_list "443,8443,2053" "443,8443,2053"
check "accept spaces around commas" has_port_list " 443 , 8443 ,2053 " "443,8443,2053"
check "normalize leading zero ports" has_port_list "00443,080" "443,80"
check "reject empty list" is_not_valid_port_list ""
check "reject empty item" is_not_valid_port_list "443,,8443"
check "reject trailing comma" is_not_valid_port_list "443,8443,"
check "reject leading comma" is_not_valid_port_list ",443"
check "reject duplicate ports" is_not_valid_port_list "443,443"
check "reject equivalent duplicate ports" is_not_valid_port_list "443,00443"
check "reject missing commas" is_not_valid_port_list "443 8443"
check "reject zero in a list" is_not_valid_port_list "443,0"
check "reject overflow in a list" is_not_valid_port_list "443,65536"
# The literal shell expression must be rejected, never evaluated.
# shellcheck disable=SC2016
check "reject shell expressions in ports" is_not_valid_port_list '443,$(id)'
check "prepare TCP and UDP for three ports" has_batch_size both "443,8443,2053" "443,8443,2053" 3 2
check "prepare ordered port mapping" has_batch_size tcp "443,2053" "8443,8080" 2 1
check "reject mismatched destination count" has_no_valid_batch tcp "443,2053" "8443"
check "accept minimum health samples" valid_samples "5"
check "accept maximum health samples" valid_samples "200"
check "accept HYBRID mode" valid_mode "hybrid"
check "accept GRE mode" valid_mode "gre"
check "accept GOST mode" valid_mode "gost"
check "reject unknown mode" is_not_valid_mode "wireguard"
check "accept public GOST path" valid_transport "public"
check "accept GRE GOST path" valid_transport "gre"
check "accept PRIVATE IPv6 GOST path" valid_transport "private"
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
check "IRAN matches reference private IPv6" is_equal "$PRIVATE_LOCAL" "fd1d:fc98:b73e:b481::2"
check "IRAN private IPv6 peer" is_equal "$PRIVATE_REMOTE" "fd1d:fc98:b73e:b481::1"

export ROLE="kharej"
validate_config
check "KHAREJ local endpoint" is_equal "$LOCAL_IP" "$KHAREJ_IP"
check "KHAREJ remote endpoint" is_equal "$REMOTE_IP" "$IRAN_IP"
check "KHAREJ GRE address" is_equal "$GRE_LOCAL" "10.77.0.2"
check "KHAREJ GRE peer" is_equal "$GRE_REMOTE" "10.77.0.1"
check "KHAREJ matches reference private IPv6" is_equal "$PRIVATE_LOCAL" "fd1d:fc98:b73e:b481::1"
check "KHAREJ private IPv6 peer" is_equal "$PRIVATE_REMOTE" "fd1d:fc98:b73e:b481::2"
check "last private IPv6 pair has valid subnet" is_equal "$(private_address kharej 15)" "fd1d:fc98:b73e:b48f::1"

printf '1..%d\n' "$tests"
(( failures == 0 ))
