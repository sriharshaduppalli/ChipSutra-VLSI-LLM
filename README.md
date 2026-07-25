# ChipSutra VLSI LLM (Ollama)

**Your own local verification-focused language model — no API keys, no credits, no cloud tokens.**

This repository defines **custom Ollama models** built on open-weight [Qwen2.5-Coder](https://ollama.com/library/qwen2.5-coder) bases. A Modelfile bakes in SystemVerilog / UVM / SVA / coverage expertise so ChipSutra and other tools get consistent DV output without calling Anthropic, OpenAI, or Emergent.

## Models

| Tag | Base (pulled once) | RAM (approx.) | Best for |
|-----|-------------------|---------------|----------|
| `chipsutra-vlsi:1.5b` | `qwen2.5-coder:1.5b` | 4 GB | Laptops, quick drafts |
| `chipsutra-vlsi:3b` | `qwen2.5-coder:3b` | 6 GB | **Default** — balance of speed and quality |
| `chipsutra-vlsi:7b` | `qwen2.5-coder:7b` | 10 GB | Workstations, richer UVM/SVA |

All weights stay on your machine via [Ollama](https://ollama.com/). You only download open models from Ollama’s library once per base tag.

## Quick start

### Windows (PowerShell)

```powershell
git clone https://github.com/sriharshaduppalli/ChipSutra-VLSI-LLM.git
cd ChipSutra-VLSI-LLM
.\scripts\create-all.ps1
```

### Linux / macOS

```bash
git clone https://github.com/sriharshaduppalli/ChipSutra-VLSI-LLM.git
cd ChipSutra-VLSI-LLM
chmod +x scripts/*.sh
./scripts/create-all.sh
```

### Manual (any OS)

```bash
ollama pull qwen2.5-coder:3b
ollama create chipsutra-vlsi:3b -f modelfiles/Modelfile.3b
ollama run chipsutra-vlsi:3b "Write SVA for a 2-deep FIFO full/empty"
```

## Use with ChipSutra

In `ChipSutra/backend/.env`:

```env
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=chipsutra-vlsi:3b
```

Docker Compose in [ChipSutra](https://github.com/sriharshaduppalli/ChipSutra) builds `chipsutra-vlsi:3b` automatically on first `docker compose up` (see `models/chipsutra-vlsi/` — synced from this repo).

## Use elsewhere

Any app that speaks Ollama’s HTTP API can use the same model name:

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "chipsutra-vlsi:3b",
  "messages": [{"role":"user","content":"Generate a UVM sequence for AXI burst"}],
  "stream": false
}'
```

Works with Open WebUI, Continue, LangChain, Cursor local models, etc.

## What this is (and isn’t)

| | |
|---|---|
| **Is** | A **specialized system prompt + parameters** on top of Qwen2.5-Coder (Ollama `create`) |
| **Is** | 100% local inference after base weights are downloaded |
| **Isn’t** | A separate multi-GB “custom weights” file in Git (bases are pulled by Ollama) |
| **Future** | Optional **LoRA fine-tune** — see [docs/FINE_TUNING.md](./docs/FINE_TUNING.md) |

## Repository layout

```
modelfiles/          Modelfile.1.5b, .3b, .7b
prompts/             Shared SYSTEM prompt (included by Modelfiles)
scripts/             create-all.sh / .ps1, verify.sh
docs/FINE_TUNING.md  Local LoRA path (no cloud credits)
LICENSE              MIT
```

## Updating the model

1. Edit `prompts/vlsi_system.txt` or a `modelfiles/Modelfile.*`.
2. Bump `VERSION` in the Modelfile comment.
3. Re-run `scripts/create-all.sh` (or one size).
4. Open a PR — ChipSutra syncs `models/chipsutra-vlsi/` from releases.

## License

MIT — see [LICENSE](./LICENSE). Qwen2.5-Coder weights are subject to [Alibaba’s license](https://github.com/QwenLM/Qwen2.5-Coder); use complies with their terms for research and commercial use.

## Contact

- ChipSutra: https://github.com/sriharshaduppalli/ChipSutra  
- Email: verification@chipsutra.ai
