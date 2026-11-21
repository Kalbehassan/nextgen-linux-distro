#!/usr/bin/env bash
set -euo pipefail

image="build/aegis-diagos.img"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --image) image="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done
archive="${image%.img}.tar.gz"
[[ -f "$archive" ]] || { echo "Missing packaged artifact: $archive" >&2; exit 1; }
[[ -f "${archive}.sha256" ]] || { echo "Missing checksum manifest" >&2; exit 1; }
expected=$(awk "{print \$1}" "${archive}.sha256")
if command -v sha256sum >/dev/null 2>&1; then actual=$(sha256sum "$archive" | awk "{print \$1}"); else actual=$(shasum -a 256 "$archive" | awk "{print \$1}"); fi
[[ "$actual" == "$expected" ]] || { echo "Checksum mismatch" >&2; exit 1; }
echo "Smoke test passed: artifact integrity verified"
