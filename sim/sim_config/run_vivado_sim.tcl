
# -------- Config --------
set part        "xc7a100tcsg324-1"          ;# Target part (NEXYS A7 100T)
set tb_top      "tb_top"                     ;# Your testbench top
set proj_name   "viavdo_sim"
set proj_dir    "./sim/results/vivado_sim"
set filelist    [glob ./rtl/**/*.sv ./sim/tb_top/*sv]      ;# All SV files recursively from rtl/ and sim/

# -------- Create project --------
create_project $proj_name $proj_dir -part $part -force
set_property target_language Verilog [current_project]
set_property top $tb_top [current_fileset]

# -------- Add files --------
foreach f $filelist {
  add_files -norecurse $f
}

# -------- Compile & simulate --------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_simulation

run all
quit
