# - Compile dependencies (ieee_proposed)
# - Compile src (irqc)
# - Compile testbench dependencies (Bitvis Utility Library, vhdl 93 version)
# - Compile and simulate irqc testbench

onerror {abort all}

quit -sim

quietly set vhdl_version "93"

quietly set tb_part_path ../../bitvis_irqc
do $tb_part_path/script/compile_dep.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_src.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_tb_dep.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_tb.do  $tb_part_path $vhdl_version
do $tb_part_path/script/simulate_tb.do $tb_part_path $vhdl_version


