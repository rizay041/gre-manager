#!/usr/bin/env bash
set -Eeuo pipefail

readonly RELEASE_BASE="https://github.com/rizay041/gre-manager/releases/latest/download"

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "این دستور باید با sudo اجرا شود." >&2; exit 1; }

for command_name in curl tar sha256sum mktemp; do
  command -v "$command_name" >/dev/null 2>&1 || { echo "ابزار لازم پیدا نشد: $command_name" >&2; exit 1; }
done

work_dir=$(mktemp -d /tmp/gre-manager-install.XXXXXX)
cleanup() { rm -rf -- "$work_dir"; }
trap cleanup EXIT

cd "$work_dir"
echo "در حال دانلود آخرین نسخه GRE Manager..."
curl -fL "$RELEASE_BASE/gre-manager-linux.tar.gz" -o gre-manager-linux.tar.gz
curl -fL "$RELEASE_BASE/gre-manager-linux.tar.gz.sha256" -o gre-manager-linux.tar.gz.sha256
sha256sum -c gre-manager-linux.tar.gz.sha256
tar -xzf gre-manager-linux.tar.gz
cd gre-manager-linux
./install.sh

echo
echo "نصب تمام شد؛ حالا چند سؤال کوتاه برای ساخت تونل می‌پرسم."
if [[ -r /dev/tty ]]; then
  /usr/local/bin/gre-manager configure </dev/tty
else
  echo "برای تنظیم تونل اجرا کنید: sudo gre-manager configure"
fi
