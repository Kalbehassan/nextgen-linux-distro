#!/usr/bin/env bash
set -euo pipefail

rootfs="build/rootfs"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --rootfs) rootfs="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

mkdir -p "$rootfs/etc/sysctl.d" "$rootfs/usr/local/bin" "$rootfs/etc"
cp overlay/etc/sysctl.d/99-hardening.conf "$rootfs/etc/sysctl.d/99-hardening.conf"
cp overlay/usr/local/bin/distro-diag "$rootfs/usr/local/bin/distro-diag"
chmod 0755 "$rootfs/usr/local/bin/distro-diag"
printf "Welcome to AegisDiagOS 0.1.0 (ironclad)\\nRun distro-diag for a system snapshot.\\n" > "$rootfs/etc/motd"
cat > "$rootfs/etc/os-release" <<OS
NAME="AegisDiagOS"
VERSION="0.1.0 (ironclad)"
ID=aegis-diagos
PRETTY_NAME="AegisDiagOS 0.1.0"
OS
echo "Configured system overlay in $rootfs"
