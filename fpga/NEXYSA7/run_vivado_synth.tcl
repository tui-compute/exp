
# -------- Configuration --------
# XC7A100T-1CSG324C
set part "xc7a100tcsg324-1"             ;# Target part (NEXYS A7 100T)
set top_module "top"                    ;# Name of the top module
set rtl_files [glob ./rtl/**/*.sv]      ;# All SV files recursively from rtl/
set proj_name "vivado_synth"
set proj_dir "./fpga/NEXYSA7/vivado_synth"

# -------- Create Project --------
create_project $proj_name $proj_dir -part $part -force
set_property target_language Verilog [current_project]
set_property top $top_module [current_fileset]

# -------- Add RTL Files --------
foreach file $rtl_files {
  add_files -norecurse $file
}

# -------- Synthesis --------
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 16
wait_on_run synth_1

# -------- Report --------
open_run synth_1
report_utilization -file ${proj_dir}/utilization.rpt
report_timing_summary -file ${proj_dir}/timing.rpt

puts "Synthesis completed. Reports saved to ${proj_dir}"
