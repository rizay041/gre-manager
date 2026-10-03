#!/usr/bin/env bash
set -Eeuo pipefail

readonly RELEASE_BASE="https://github.com/rizay041/gre-manager/releases/latest/download"
readonly INSTALLER_VERSION="3.0.1"

border='\033[38;5;27m'
blue='\033[1;94m'
accent='\033[1;96m'
reset='\033[0m'
printf '%b%s%b\n' "$border" '................................................................................' "$reset"
printf '%b' "$blue"
cat <<'EOF'
.............  ...........  .............       ...       ...         ...
...       ...      ...              ...        .....      ...         ...
...       ...      ...             ...        ... ...      ...       ...
.............      ...            ...        ...   ...      ...     ...
...   ...          ...          ....        ...     ...      ...   ...
...    ...         ...        ....         .............      .......
...     ...        ...       ...           ...       ...        ...
...      ...       ...      ...            ...       ...        ...
...       ...  ...........  .............  ...       ...        ...
EOF
printf '%b' "$reset"
printf '%b%47s%b\n' "$accent" 'RIZAY INSTALLER' "$reset"
printf '%b%44s v%s%b\n' "$border" 'VERSION' "$INSTALLER_VERSION" "$reset"
printf '%b%s%b\n\n' "$border" '................................................................................' "$reset"

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "Run this command with sudo." >&2; exit 1; }

for command_name in curl tar sha256sum mktemp; do
  command -v "$command_name" >/dev/null 2>&1 || { echo "Required tool not found: $command_name" >&2; exit 1; }
done

work_dir=$(mktemp -d /tmp/gre-manager-install.XXXXXX)
cleanup() { rm -rf -- "$work_dir"; }
trap cleanup EXIT

cd "$work_dir"
echo "RIZAY: downloading the latest GRE Manager release..."
curl -fL "$RELEASE_BASE/gre-manager-linux.tar.gz" -o gre-manager-linux.tar.gz
curl -fL "$RELEASE_BASE/gre-manager-linux.tar.gz.sha256" -o gre-manager-linux.tar.gz.sha256
sha256sum -c gre-manager-linux.tar.gz.sha256
tar -xzf gre-manager-linux.tar.gz
cd gre-manager-linux
./install.sh

echo
echo "Install completed. Starting the IRAN/KHAREJ graphical wizard..."
if [[ -r /dev/tty ]]; then
  /usr/local/bin/gre-manager wizard </dev/tty
else
  echo "Start setup with: sudo gre-manager wizard"
fi
