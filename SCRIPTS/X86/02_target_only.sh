#!/bin/bash
set -euo pipefail

#sed -i 's/O2/O2 -march=x86-64-v2/g' include/target.mk

# libsodium
sed -i 's,no-mips16 no-lto,no-mips16,g' feeds/packages/libs/libsodium/Makefile

echo '#!/bin/sh
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

if grep -q "Default string" /tmp/sysinfo/model 2>/dev/null; then
    echo "Generic PC" > /tmp/sysinfo/model
fi

PSTATE_STATUS_FILE="/sys/devices/system/cpu/intel_pstate/status"
if [ -f "$PSTATE_STATUS_FILE" ]; then
    if [ "$(cat "$PSTATE_STATUS_FILE")" = "passive" ]; then
        echo "active" > "$PSTATE_STATUS_FILE"
    fi
    for cpu_gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu_gov" ] && echo "powersave" > "$cpu_gov"
    done
    for cpu_epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        [ -f "$cpu_epp" ] && echo "balance_performance" > "$cpu_epp"
    done
fi

exit 0
' > ./package/base-files/files/etc/rc.local

# Vermagic: use the exact release selected during source preparation. If this
# script is run independently, resolve the latest stable release in the series
# from the official OpenWrt download index.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=00_openwrt_release.sh
. "${SCRIPT_DIR}/00_openwrt_release.sh"

OPENWRT_RELEASE_SERIES="$(detect_openwrt_release_series)"
export OPENWRT_RELEASE_SERIES
latest_version="$(resolve_openwrt_release)"
profiles_url="https://downloads.openwrt.org/releases/${latest_version}/targets/x86/64/profiles.json"
profiles_file="$(mktemp)"
trap 'rm -f "$profiles_file"' EXIT

echo "Loading x86/64 vermagic from OpenWrt ${latest_version}"
curl -fsSL \
  --retry 5 \
  --retry-delay 2 \
  --retry-all-errors \
  --connect-timeout 15 \
  --max-time 90 \
  "$profiles_url" \
  -o "$profiles_file"

vermagic="$(jq -er '.linux_kernel.vermagic | strings | select(length > 0)' "$profiles_file")"
release_kernel="$(jq -er '.linux_kernel.version | strings | select(length > 0)' "$profiles_file")"
source_kernel="$(sed -n 's/^KERNEL_PATCHVER:=//p' ./target/linux/x86/Makefile)"

case "$release_kernel" in
  "${source_kernel}."*) ;;
  *)
    echo "Error: OpenWrt ${latest_version} uses kernel ${release_kernel}, but the source expects ${source_kernel}.x." >&2
    exit 1
    ;;
esac

printf '%s\n' "$vermagic" >.vermagic
sed -i -e 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk

# 预配置一些插件
cp -rf ../PATCH/files ./files

find ./ -name *.orig | xargs rm -f
find ./ -name *.rej | xargs rm -f

exit 0
