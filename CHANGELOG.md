# Changelog

## [1.2.1] — 2026-07-29

- Added `prompts/covergroup_patterns.txt` for ChipSutra RAG (bins, crosses, protocol coverpoints, closure workflow).
- Sync contract: ChipSutra copies four RAG prompt files (protocols, SoC/DFT, glossary, covergroups).

## [1.2.0] — 2026-07-26

- Expanded Modelfile SYSTEM protocol index (AMBA deep, Wishbone/Avalon/TileLink, PCIe/CXL, Eth/MDIO, DDR/HBM, I3C/QSPI/I2S, CAN-FD/LIN, JTAG/DFT, UCIe/BoW, CDC/UPF, RISC-V SoC glue).
- New RAG prompt files: `vlsi_soc_dft_power.txt`, `vlsi_verification_glossary.txt`; expanded `vlsi_protocols_compact.txt`.
- Documented honesty: accuracy = Modelfile index + ChipSutra RAG + user RTL — not weight-only memorization.
- Sync contract: ChipSutra copies all three RAG prompt files; bootstrap recreates on VERSION change.

## [1.1.0] — 2026-07-26

- Protocol appendix in Modelfiles; `VERSION` file; `ACCURACY_AND_KNOWLEDGE.md` roadmap.
- Compact protocol prompt for ChipSutra keyword RAG sync.

## [1.0.0] — 2026-07-25

- Initial Modelfiles for `chipsutra-vlsi:1.5b|3b|7b` on Qwen2.5-Coder via Ollama.
