# EXP Platform Makefile

CONFIG ?= mac_array_4x4
CONFIG_FILE := configs/$(CONFIG).json
GEN_TOP := rtl/top/generated_top.sv
TB_DIR := sim/tb_$(CONFIG)
TB_TOP := tb_$(CONFIG)
TEST_VECTOR := $(TB_DIR)/$(TB_TOP)_test_vectors.sv

# Verilator simulation
verilator: $(GEN_TOP)
	verilator -Wall -cc $(TB_DIR)/$(TB_TOP).sv \
		--top-module $(TB_TOP) \
		--exe $(TEST_VECTOR) \
		-CFLAGS -std=c++17 \
		--Mdir sim/obj_dir_$(CONFIG) \
		--trace
	make -C sim/obj_dir_$(CONFIG) -f V$(TB_TOP).mk V$(TB_TOP)
	sim/obj_dir_$(CONFIG)/V$(TB_TOP)

# QuestaSim simulation
questa: $(GEN_TOP)
	vlog -sv -f sim/sim_config/questa.f
	vsim -c -do sim/sim_config/run_questa.tcl

# Vivado simulation
vivado_sim: $(GEN_TOP)
	vivado -mode batch -source sim/sim_config/run_vivado.tcl

# Generate the top-level RTL from config
$(GEN_TOP): $(CONFIG_FILE) scripts/gen_top.py
	python3 scripts/gen_top.py --config $(CONFIG_FILE) --output $(GEN_TOP)

# List available config files
list_configs:
	@echo "Available configurations:"
	@ls configs/*.json | xargs -n1 basename | sed 's/\.json//'

# Cleanup generated files
clean:
	rm -rf sim/obj_dir_* *.vcd *.log $(GEN_TOP)

.PHONY: verilator questa vivado_sim list_configs clean

