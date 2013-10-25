onerror {abort all}

quit -sim

# Argument number 1 : VHDL Version. Default 2002
quietly set vhdl_version "2002"
if { [info exists 1] } {
  quietly set vhdl_version "$1"
  unset 1
}

quietly set tb_part_path ../../bitvis_irqc
do $tb_part_path/script/compile_dep.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_src.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_tb_dep.do $tb_part_path $vhdl_version
do $tb_part_path/script/compile_tb.do  $tb_part_path $vhdl_version
do $tb_part_path/script/simulate_tb.do $tb_part_path $vhdl_version


