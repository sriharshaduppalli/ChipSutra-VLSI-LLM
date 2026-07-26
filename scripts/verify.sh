#!/usr/bin/env bash
set -euo pipefail
MODEL="${1:-chipsutra-vlsi:3b}"
PROMPT="${2:-Write one SVA property for async reset deassertion sync to clk. Output SV only.}"
if ! command -v ollama >/dev/null 2>&1; then
  echo "ERROR: Ollama not found. Install from https://ollama.com/download" >&2
  exit 1
fi
if ! ollama show "$MODEL" >/dev/null 2>&1; then
  echo "ERROR: model $MODEL missing. Run ./scripts/create-all.sh" >&2
  exit 1
fi
curl -sf "http://localhost:11434/api/chat" -d "{
  \"model\": \"${MODEL}\",
  \"stream\": false,
  \"messages\": [{\"role\":\"user\",\"content\":$(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$PROMPT")}]
}" | python3 -c "import sys,json; print(json.load(sys.stdin)['message']['content'][:500])"
echo ""
echo "[verify] OK — model ${MODEL} responded"
