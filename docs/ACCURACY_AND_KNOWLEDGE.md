# Accuracy, knowledge, and “learning” for ChipSutra-VLSI

ChipSutra-VLSI is **not** a continuously self-updating brain like a hosted ChatGPT with live training. It is:

1. **Qwen2.5-Coder** (open weights, via Ollama)
2. Plus a **fixed SYSTEM prompt** (Modelfile) and parameters
3. Plus **your RTL/spec/logs** injected at request time by the ChipSutra app

Improving “accuracy” means improving **those layers** — not expecting the base model to magically learn new protocols overnight.

---

## What works today (v1.1)

| Layer | What we did |
|-------|-------------|
| **Prompt** | `prompts/vlsi_system.txt` + `prompts/vlsi_protocols_compact.txt` baked into Modelfiles |
| **Context** | ChipSutra sends selected files + module-specific system prompts in `server.py` |
| **Params** | Lower temperature on 7b, `num_ctx` 8k on 3b/7b for larger RTL snippets |

---

## What “learning graphs” would mean (roadmap)

A **knowledge graph** (protocols ↔ signals ↔ properties ↔ coverage points) is **not stored inside Ollama** today. Practical paths:

### Path 1 — RAG in ChipSutra (recommended next for OSS)

- Store **curated** markdown/JSON: AXI rules, CAN frame diagram, UVM patterns, debug playbooks.
- On **Generate**, retrieve chunks (embedding search or keyword) and prepend to the user message.
- **Pros:** Updatable without retraining; cite sources; India-friendly air-gapped if index is local.
- **Cons:** Needs engineering in ChipSutra backend, not only this repo.

### Path 2 — LoRA / fine-tune (this repo + GPU)

- Build JSONL from **reviewed** pairs (RTL in → UVM/SVA out) on open DUTs (Ibex, FIFO, CAN ctrl).
- Train adapter; import GGUF into Ollama as `chipsutra-vlsi:3b-ft`.
- See [FINE_TUNING.md](./FINE_TUNING.md).

### Path 3 — Tool-augmented generation (ChipSutra + EDA tools)

- Parse ports with Verilator/slang; pass **structured port list** into prompt (already on ChipSutra ROADMAP).
- Run lint/sim; feed logs back into **debug** module (closed loop).

### Path 4 — Bigger base model / cloud fallback

- `chipsutra-vlsi:7b` locally; optional Claude/GPT keys in ChipSutra for hard SoC blocks.

**Avoid:** Claiming the Modelfile “learns” from every user session without an explicit training pipeline and consent.

---

## Curated knowledge to add over time

| Domain | Source style | Use |
|--------|----------------|-----|
| Protocols | Accellera / ARM AMBA summaries, ISO CAN, PCIe base spec outlines | RAG chunks + prompt appendix |
| UVM | UVM 1.2 cookbook patterns | Few-shot examples in JSONL for LoRA |
| SVA | OpenRVVI / formal examples | Golden properties in regression suite |
| Sim debug | Common UVM message catalog | Debug module templates |
| Coverage | Covergroup patterns per protocol | `coverage_holes` module |

License: only **redistributable** text in public repos; keep proprietary customer IP out of public graphs.

---

## Versioning & sync with ChipSutra

1. Bump **`VERSION`** in this repo when prompts/Modelfiles change.
2. Tag release `v1.1.0` on GitHub.
3. Run ChipSutra **`scripts/sync-vlsi-llm.sh`** or Actions **Sync ChipSutra-VLSI modelfiles**.
4. Rebuild Ollama tags: `scripts/create-all.sh` or Docker `ollama-bootstrap.sh`.

---

## How to measure accuracy

- **Golden regression:** fixed DUTs + expected SVA/TB snippets (human-reviewed).
- **Lint pass rate:** Verilator `--lint-only` on generated RTL subset.
- **User feedback loop:** thumbs on generations (ChipSutra roadmap) → export for LoRA.

Update this doc as RAG or fine-tuned tags ship.
