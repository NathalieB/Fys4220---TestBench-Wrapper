# Compile Bitvis Util
#----------------------------------

# This file may be called with an argument
# arg 1: Part directory of this library/module
# arg 2: VHDL version number (93, 2002 or 2008)

onerror {abort all}
quit -sim   #Just in case...

# Set up util_part_path and lib_name
#------------------------------------------------------
quietly set lib_name "bitvis_util"
quietly set part_name "bitvis_util"
# path from mpf-file in sim
quietly set util_part_path "../..//$part_name"

if { [info exists 1] } {
  # path from this part to target part
  quietly set util_part_path "$1/..//$part_name"
  unset 1
}
# Argument number 2 : VHDL Version. Default 2002
quietly set vhdl_version "2002"
if { [info exists 2] } {
  quietly set vhdl_version "$2"
  unset 2
}

do $util_part_path/script/compile_dep.do $util_part_path $vhdl_version
do $util_part_path/script/compile_src.do $util_part_path $vhdl_version


# VIP SBI : BFM
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

do $vip_sbi_part_path/script/compile_src_bfm.do $vip_sbi_part_path

