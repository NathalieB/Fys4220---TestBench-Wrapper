# Compile src93 (vhdl version 93)
# This file may be called with an argument
# Arg : Part directory of this library/module

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

quietly set vhdl_version "93"
do $util_part_path/script/compile_src.do $util_part_path $vhdl_version
