#!/usr/bin/env bash
set -euo pipefail

profile="profiles/diag-appliance.yaml"
rootfs="build/rootfs"
image="build/aegis-diagos.img"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) profile="$2"; shift 2 ;;
    --rootfs) rootfs="$2"; shift 2 ;;
    --image) image="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[[ -d "$rootfs" ]] || { echo "Missing rootfs: $rootfs" >&2; exit 1; }
mkdir -p "$(dirname "$image")"
archive="${image%.img}.tar.gz"
tar -C "$rootfs" -czf "$archive" .
if command -v sha256sum >/dev/null 2>&1; then sha256sum "$archive" > "${archive}.sha256"; else shasum -a 256 "$archive" > "${archive}.sha256"; fi
touch "$image"
printf "AegisDiagOS archive=%s profile=%s\n" "$archive" "$profile" > "${image%.img}.manifest"
echo "Packaged: $archive"
echo "Manifest: ${image%.img}.manifest"
