# This file may be called with an argument
# arg 1: Part directory of this library/module

onerror {abort all}
quit -sim   #Just in case...

# Set up irqc_part_path and lib_name
#------------------------------------------------------
quietly set lib_name "bitvis_irqc"
quietly set part_name "bitvis_irqc"
# path from mpf-file in sim
quietly set irqc_part_path "../..//$part_name"

if { [info exists 1] } {
  # path from this part to target part
  quietly set irqc_part_path "$1/..//$part_name"
  unset 1
}


# (Re-)Generate library and Compile source files
#--------------------------------------------------
echo "\n\nRe-gen lib and compile $lib_name source\n"
if {[file exists $irqc_part_path/sim/$lib_name]} {
  vdel -all -lib $irqc_part_path/sim/$lib_name
}
if {![file exists $irqc_part_path/sim]} {
  file mkdir $irqc_part_path/sim
}

vlib $irqc_part_path/sim/$lib_name
vmap $lib_name $irqc_part_path/sim/$lib_name

set compdirectives "-2002 -work $lib_name"

eval vcom  $compdirectives  $irqc_part_path/src/irqc_pif_pkg.vhd
eval vcom  $compdirectives  $irqc_part_path/src/irqc_pif.vhd
eval vcom  $compdirectives  $irqc_part_path/src/irqc_core.vhd
eval vcom  $compdirectives  $irqc_part_path/src/irqc.vhd
