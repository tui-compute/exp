
# -------- Configuration --------
set tb_top "tb_top"
set sim_dir "sim/results/questa_sim"
set worklib "${sim_dir}/work"
set vcdfile "${sim_dir}/tb_top_sim.vcd"

file mkdir $sim_dir
vlib $worklib
vmap work $worklib

# -------- Auto-discover RTL files --------
set filelist    [glob ./rtl/**/*.sv]      ;# All SV files recursively from rtl/ and sim/
set tb_file     "sim/tb_top/${tb_top}.sv"

# -------- Compile all RTL files --------
foreach file $filelist {
  puts "Compiling RTL: $file"
  vlog -sv +acc=rn -work work $file
}

# -------- Compile testbench --------
puts "Compiling TB: $tb_file"
vlog -sv +acc=rn -work work $tb_file

# -------- Simulate with waveform output --------
vsim -c work.$tb_top -do "
  vcd file $vcdfile;
  vcd add -r /*;
  run -all;
  quit;
"
