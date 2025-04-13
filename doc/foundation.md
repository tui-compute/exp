# EXP Platform Project Foundation

## Project Overview
**Name:** EXP — EXtensions Platform  
**Purpose:** Modular hardware accelerator platform with configurable processing elements, scratchpad memory, and control fabric.

---

## ✅ Foundation Checklist

### 🔧 Build System
- [x] Makefile for orchestration
- [x] Python 3 for generation scripts
- [x] Jinja2 for RTL/code templating
- [x] JSON for architecture/config definition

### 📂 Directory Structure (Minimal & Scalable)
- `rtl/` — core RTL (PEs, scratchpad, interfaces, top)
- `hls/` — HLS components and scripts
- `sim/` — simulation testbenches and configurations
- `fpga/` — board-specific constraints and builds
- `scripts/` — build, code generation, automation helpers
- `configs/` — JSON files defining platform variants
- `templates/` — Jinja2 templates for auto-generated code
- `external/` — external IP blocks or submodules
- `doc/` — documentation, specs, diagrams

### 🧪 Simulation Infrastructure
- [x] Verilator support
- [x] QuestaSim support
- [x] Vivado simulator support
- [ ] Self-checking testbenches (WIP)
- [x] Configurable testbenches using `CONFIG=...`
- [ ] Organized waveform/log output under `sim/results/<config>`

### 🛠️ Tooling
- Python 3.10+
- Vivado 2023.2
- Verilator 5.x
- Optional: svlint, verible, GitHub Actions CI

### 📝 Metadata
- Stored in `project.json`
- Declares project metadata, versions, targets, default config

### 📄 Documentation
- `README.md`
- `foundation.md` (this file)
- `scratchpad.md`, `interfaces.md`, etc. (optional detailed specs)

---

## 🔧 Build Example
```sh
make verilator CONFIG=mac_array_4x4
make questa CONFIG=alu_grid_2x2
make vivado_sim
```

---

## 🧩 Config + Template Flow
- Define system variant in `configs/*.json`
- Generate `generated_top.sv` using Jinja2 via `gen_top.py`
- Build RTL simulation using generated source

---

## 🧠 Recommendations
- Document configurations with expected behavior
- Use testbenches with coverage assertions and reference outputs
- Prefer parameterized modules and clean, reusable interfaces
- Keep simulation and synthesis cleanly separated
- Validate generated RTL with lint (`verilator --lint-only`)

---

Let’s build scalable silicon the smart way. 💡


