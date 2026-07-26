# ChipSutra VLSI LLM (Ollama)

**Version: 1.2.0** — [CHANGELOG.md](./CHANGELOG.md) · [docs/ACCURACY_AND_KNOWLEDGE.md](./docs/ACCURACY_AND_KNOWLEDGE.md)

**Version 1.2.0** — see [CHANGELOG.md](./CHANGELOG.md).

Your own local verification-focused language model — no API keys, no credits, no cloud tokens.

This repository defines **custom Ollama models** built on open-weight [Qwen2.5-Coder](https://ollama.com/library/qwen2.5-coder) bases. Modelfiles bake in an **inline SYSTEM** prompt (SystemVerilog / UVM / SVA / protocol index). ChipSutra also injects **RAG** from `prompts/vlsi_*.txt` at generate time.

## Knowledge architecture

The Ollama SYSTEM is inline in `modelfiles/Modelfile.*`. ChipSutra retrieves additional domain context from:

- `prompts/vlsi_protocols_compact.txt`
- `prompts/vlsi_soc_dft_power.txt`
- `prompts/vlsi_verification_glossary.txt`

`prompts/vlsi_system.txt` is a human-readable reference; Ollama does not auto-include it.

## Models

| Tag | Base (pulled once) | RAM (approx.) | Best for |
|-----|-------------------|---------------|----------|
| `chipsutra-vlsi:1.5b` | `qwen2.5-coder:1.5b` | 4 GB | Laptops, quick drafts |
| `chipsutra-vlsi:3b` | `qwen2.5-coder:3b` | 6 GB | **Default** — balance of speed and quality |
| `chipsutra-vlsi:7b` | `qwen2.5-coder:7b` | 10 GB | Workstations, richer UVM/SVA |

All weights stay on your machine via [Ollama](https://ollama.com/). You only download open models from Ollama’s library once per base tag.

## Dependencies

| Required | Optional |
|----------|----------|
| [Ollama](https://ollama.com/) only | GPU drivers for faster inference |
| Internet **once** to pull `qwen2.5-coder:*` base weights | ChipSutra app (separate repo) |

No Python, Node, Anthropic, OpenAI, or Emergent accounts. No API tokens after bases are downloaded.

## Integrated with ChipSutra

Docker Compose in [ChipSutra](https://github.com/sriharshaduppalli/ChipSutra) vendors these Modelfiles under `models/chipsutra-vlsi/` and runs `ollama create` on first startup and after `VERSION` changes.

Clone this repo only if you want to rebuild tags manually or use ChipSutra-VLSI in other tools (Open WebUI, scripts, etc.).


## Quick start

**Only dependency:** [Ollama](https://ollama.com/). The repo can install it on Windows via `winget` — no Python, Node, or API keys.

### Windows

```powershell
git clone https://github.com/sriharshaduppalli/ChipSutra-VLSI-LLM.git
cd ChipSutra-VLSI-LLM
.\setup.ps1 -InstallDependencies -Tag 3b
```

Default tag `3b` matches ChipSutra Docker. Use `-Tag all` for 1.5b/3b/7b.

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
prompts/             SYSTEM reference + RAG knowledge corpus
scripts/             create-all.sh/.ps1, verify.sh/.ps1
docs/                Accuracy roadmap + optional LoRA path
CHANGELOG.md         Release notes
VERSION              Semver synced into ChipSutra
LICENSE              MIT
```

## Updating the model

1. Edit the inline SYSTEM in `modelfiles/Modelfile.*` and/or `prompts/vlsi_*.txt`.
2. Keep `prompts/vlsi_system.txt` aligned with the 3B reference.
3. Bump `VERSION` and update `CHANGELOG.md`.
4. Re-run `scripts/create-all.sh` / `.ps1`.
5. Sync ChipSutra with its sync script or GitHub Action.

Accuracy roadmap: [docs/ACCURACY_AND_KNOWLEDGE.md](./docs/ACCURACY_AND_KNOWLEDGE.md).

## License

MIT — see [LICENSE](./LICENSE). Qwen2.5-Coder weights are subject to [Alibaba’s license](https://github.com/QwenLM/Qwen2.5-Coder); use complies with their terms for research and commercial use.

## Contact

- ChipSutra: https://github.com/sriharshaduppalli/ChipSutra  
- Email: verification@chipsutra.ai
