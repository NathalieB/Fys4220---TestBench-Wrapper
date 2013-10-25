# This file may be called with an argument
# arg 1: Part directory of this library/module

onerror {abort all}

# Set up part_path and lib_name
#------------------------------------------------------
quietly set lib_name "ieee_proposed"
quietly set part_name "x_ieee_proposed"
# path from mpf-file in sim
quietly set part_path "../..//$part_name"

if { [info exists 1] } {
  # path from this part to target part
  quietly set part_path "$1/..//$part_name"
  unset 1
}



if {[file exists $part_path/sim/$lib_name]} {
  vdel -all -lib $part_path/sim/$lib_name
}
if {![file exists $part_path/sim]} {
  file mkdir $part_path/sim
}

vlib $part_path/sim/$lib_name
vmap $lib_name $part_path/sim/$lib_name


echo "\n\n\n=== Compiling $lib_name source\n"
vcom -93 -work $lib_name $part_path/src/standard_additions_c.vhdl
vcom -93 -work $lib_name $part_path/src/standard_textio_additions_c.vhdl
vcom -93 -work $lib_name $part_path/src/std_logic_1164_additions.vhdl
vcom -93 -work $lib_name $part_path/src/numeric_std_additions.vhdl
