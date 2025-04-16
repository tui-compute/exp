# EXP Platform Makefile

CONFIG 			?= top_dispatch_pe_collect
CONFIG_TB 		?= tb_dispatch_pe_collect

CONFIG_FILE 	:= configs/$(CONFIG).yml
CONFIG_FILE_TB 	:= configs/$(CONFIG_TB).yml

GEN_TOP 		:= rtl/top/top.sv
GEN_TB	 		:= sim/tb_top/tb_top.sv

TB_DIR 			:= sim/tb_top
TB_TOP 			:= $(TB_DIR)/tb_top.sv

TOP_DIR			:= rtl/top

FPGA 			:= NEXYSA7

# Verilator simulation
verilator: $(GEN_TOP) $(GEN_TB)
	verilator --lint-only -Wall $(TB_DIR)/$(TB_TOP)

# QuestaSim simulation
questa: $(GEN_TOP) $(GEN_TB)
	vsim -c -do sim/sim_config/run_questa.tcl

# Vivado simulation
vivado_sim: $(GEN_TOP) $(GEN_TB)
	vivado -mode batch -source sim/sim_config/run_vivado_sim.tcl

# Vivado syntehsis
vivado_synth: $(GEN_TOP)
	vivado -mode batch -source fpga/$(FPGA)/run_vivado_synth.tcl

# Generate the top-level RTL from config
$(GEN_TOP): $(CONFIG_FILE) scripts/gen_top.py
	mkdir -p $(TOP_DIR)
	python3 scripts/gen_top.py --config $(CONFIG_FILE) --output $(GEN_TOP) --template top_template.sv.j2

# Generate the tb from config
$(GEN_TB): $(CONFIG_FILE_TB) scripts/gen_tb.py
	mkdir -p $(TB_DIR)
	python3 scripts/gen_tb.py --config $(CONFIG_FILE_TB) --output $(GEN_TB) --template tb_template.sv.j2

# List available config files
list_configs:
	@echo "Available configurations:"
	@ls configs/*.yml | xargs -n1 basename | sed 's/\.yml//'

# Cleanup generated files
clean:
	rm -rf sim/obj_dir_* *.vcd *.log $(GEN_TOP) $(GEN_TB) transcript
	rm -rf sim/results/*

.PHONY: verilator questa vivado_sim list_configs clean
