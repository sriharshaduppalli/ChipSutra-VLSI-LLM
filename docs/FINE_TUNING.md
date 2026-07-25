# Optional: true fine-tune (still zero cloud credits)

The default **ChipSutra-VLSI** models use Ollama `create` with a domain system prompt on Qwen2.5-Coder. That costs **no tokens** after you download bases.

For a **custom weight delta** (LoRA), run entirely on your GPU:

## Path A — Unsloth + QLoRA (recommended)

1. Prepare JSONL: `{ "instruction": "...", "input": "<rtl>", "output": "<uvm/sva>" }` from your anonymized projects or public RTL (Apache-2.0 repos).
2. Fine-tune `Qwen2.5-Coder-3B-Instruct` with [Unsloth](https://github.com/unslothai/unsloth) on a local NVIDIA GPU.
3. Export GGUF and import into Ollama:

```bash
# After export to my-vlsi-lora.gguf (tooling-specific)
# See Ollama docs for adapter / custom model import for your export format.
```

4. Tag as `chipsutra-vlsi:3b-ft` and set `OLLAMA_MODEL=chipsutra-vlsi:3b-ft` in ChipSutra.

## Path B — Keep prompt-only (current repo)

Update `prompts/vlsi_system.txt` and rebuild with `scripts/create-all.sh`. No GPU required.

## Dataset ideas (open / shareable)

- Ibex, PicoRV32, serv — generate golden UVM skeletons + review manually
- Your `UVM_TB_AUTOGEN` repo patterns
- Accellera UVM examples (respect their licenses)

## Legal

Do not fine-tune on proprietary customer RTL without contract rights. Prefer open-source DUTs for public model releases.
