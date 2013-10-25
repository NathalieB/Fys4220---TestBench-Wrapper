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


# Testbenches reside in the design library. Hence no regeneration of lib.
#------------------------------------------------------------------------

set compdirectives "-2002 -work $lib_name"

eval vcom  $compdirectives  $irqc_part_path/tb/irqc_tb.vhd
