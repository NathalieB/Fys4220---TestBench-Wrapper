onerror {resume}
quit -sim

#onerror {abort all}


vsim  bitvis_irqc.irqc_tb


add log -r /*
source ../script/wave.do


run -all

