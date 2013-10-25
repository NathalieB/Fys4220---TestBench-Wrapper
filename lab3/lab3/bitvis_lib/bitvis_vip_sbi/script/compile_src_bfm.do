# This file may be called with an argument
# arg 1: Part directory of this library/module

onerror {abort all}
quit -sim   #Just in case...

# Set up vip_sbi_part_path and lib_name
#------------------------------------------------------
quietly set lib_name "bitvis_vip_sbi"
quietly set part_name "bitvis_vip_sbi"
# path from mpf-file in sim
quietly set vip_sbi_part_path "../..//$part_name"

if { [info exists 1] } {
  # path from this part to target part
  quietly set vip_sbi_part_path "$1/..//$part_name"
  unset 1
}


# (Re-)Generate library and Compile source files
#--------------------------------------------------
echo "\n\nRe-gen lib and compile $lib_name source\n"
if {[file exists $vip_sbi_part_path/sim/$lib_name]} {
  vdel -all -lib $vip_sbi_part_path/sim/$lib_name
}
if {![file exists $vip_sbi_part_path/sim]} {
  file mkdir $vip_sbi_part_path/sim
}

vlib $vip_sbi_part_path/sim/$lib_name
vmap $lib_name $vip_sbi_part_path/sim/$lib_name

set compdirectives "-93 -work $lib_name"

eval vcom  $compdirectives  $vip_sbi_part_path/src/sbi_bfm_pkg.vhd
#vcom  $compdirectives  ../tb/sbi_tb_pkg.vhd
#vcom  $compdirectives  ../src/sbi_executor_pkg.vhd
#vcom  $compdirectives  ../src/sbi_vc.vhd
