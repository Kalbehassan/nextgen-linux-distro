#!/usr/bin/env bash
set -euo pipefail

profile="profiles/diag-appliance.yaml"
rootfs="build/rootfs"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) profile="$2"; shift 2 ;;
    --rootfs) rootfs="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[[ -f "$profile" ]] || { echo "Missing profile: $profile" >&2; exit 1; }
mkdir -p "$rootfs"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  echo "Building rootfs with Docker..."
  docker run --rm -v "$PWD:/work" -w /work alpine:3.20 sh -ec "apk add --no-cache bash curl jq procps iproute2 ca-certificates tar && mkdir -p /tmp/rootfs && tar -C / -cf /work/build/rootfs.tar ."
  rm -rf "$rootfs" && mkdir -p "$rootfs"
  tar -xf build/rootfs.tar -C "$rootfs"
else
  echo "Docker unavailable; creating minimal deterministic rootfs scaffold."
  mkdir -p "$rootfs/bin" "$rootfs/etc" "$rootfs/proc" "$rootfs/sys" "$rootfs/dev" "$rootfs/usr/local/bin" "$rootfs/var/log" "$rootfs/run"
  cp overlay/etc/sysctl.d/99-hardening.conf "$rootfs/etc/99-hardening.conf"
  cp overlay/usr/local/bin/distro-diag "$rootfs/usr/local/bin/distro-diag"
fi

echo "Rootfs ready: $rootfs"
