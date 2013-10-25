# This file may be called with an argument
# arg 1: Part directory of this library/module
# arg 2: 93 | 2002 | 2008 Default vhdl 2002

onerror {abort all}

# Set up util_part_path and lib_name
#------------------------------------------------------
quietly set lib_name "bitvis_util"
quietly set part_name "bitvis_util"
# path from mpf-file in sim
quietly set util_part_path "../..//$part_name"

# argument number 1
if { [info exists 1] } {
  # path from this part to target part
  quietly set util_part_path "$1/..//$part_name"
  unset 1
}

# Default vhdl_version: 
quietly set vhdl_version "2002"
#quietly set vhdl_version "2008"
#quietly set vhdl_version "93"

# Check vhdl_version in argument number 2
if { [info exists 2] } {
  # VHDL version
  quietly set vhdl_version "$2"
  unset 2
}

# Compile from different folders depending on vhdl_version
# src93, src2002 or src2008
quietly set src_dir "src$vhdl_version" 

# (Re-)Generate library and Compile source files
#--------------------------------------------------
echo "\n\nRe-gen lib and compile $lib_name source"
echo "- VHDL version $vhdl_version\n"
if {[file exists $util_part_path/sim/$lib_name]} {
  vdel -all -lib $util_part_path/sim/$lib_name
}
if {![file exists $util_part_path/sim]} {
  file mkdir $util_part_path/sim
}

vlib $util_part_path/sim/$lib_name
vmap $lib_name $util_part_path/sim/$lib_name

quietly set compdirectives "-suppress 1346,1236 -$vhdl_version -work $lib_name"

echo "\n\n\n=== Compiling $lib_name source\n"
eval vcom  $compdirectives   $util_part_path/$src_dir/types_pkg.vhd
eval vcom  $compdirectives   $util_part_path/$src_dir/adaptations_pkg.vhd
eval vcom  $compdirectives   $util_part_path/$src_dir/string_methods_pkg.vhd
# Protected types only suppored in the 21st century!
if {[string match $vhdl_version "2002"] 
 || [string match $vhdl_version "2008"]} {
  eval vcom  $compdirectives   $util_part_path/$src_dir/protected_types_pkg.vhd }

eval vcom  $compdirectives   $util_part_path/$src_dir/vhdl_version_layer_pkg.vhd 

eval vcom  $compdirectives   $util_part_path/$src_dir/license_open_pkg.vhd
eval vcom  $compdirectives   $util_part_path/$src_dir/methods_pkg.vhd
eval vcom  $compdirectives   $util_part_path/$src_dir/bfm_common_pkg.vhd
