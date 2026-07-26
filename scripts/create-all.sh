#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
VERSION="$(tr -d '[:space:]' < VERSION)"
echo "[chipsutra-vlsi] building VERSION=${VERSION}"

create_one() {
  local tag="$1"
  local base="$2"
  local file="$3"
  echo "[chipsutra-vlsi] pulling base ${base}..."
  ollama pull "${base}"
  grep -q "v${VERSION}" "${file}" || {
    echo "ERROR: ${file} header does not match VERSION=${VERSION}" >&2
    exit 1
  }
  echo "[chipsutra-vlsi] creating chipsutra-vlsi:${tag}..."
  ollama create "chipsutra-vlsi:${tag}" -f "${file}"
}

create_one "1.5b" "qwen2.5-coder:1.5b" "modelfiles/Modelfile.1.5b"
create_one "3b"   "qwen2.5-coder:3b"   "modelfiles/Modelfile.3b"
create_one "7b"   "qwen2.5-coder:7b"   "modelfiles/Modelfile.7b"

echo "[chipsutra-vlsi] done. Try: ollama run chipsutra-vlsi:3b"
