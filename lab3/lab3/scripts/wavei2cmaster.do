view wave
delete wave *


#input
add wave -divider 
add wave -divider I2C_master 
add wave -divider 

add wave -divider i2c_master_input
add wave /tb_i2c_master/uut/system_clk
add wave /tb_i2c_master/uut/bus_clk
add wave /tb_i2c_master/uut/clk
add wave /tb_i2c_master/uut/areset_n
add wave /tb_i2c_master/uut/ena
add wave /tb_i2c_master/uut/addr
add wave /tb_i2c_master/uut/data_wr
add wave /tb_i2c_master/uut/rnw

#output
add wave -divider i2c_master_ouput
add wave /tb_i2c_master/uut/busy
add wave /tb_i2c_master/uut/ack_error


#output
add wave -divider scl_related

#internal clk related
add wave /tb_i2c_master/uut/scl_clk
add wave /tb_i2c_master/uut/scl_oe
add wave /tb_i2c_master/uut/scl_high_ena
add wave /tb_i2c_master/uut/state_ena

#data
add wave -divider data_related
add wave /tb_i2c_master/uut/state
add wave /tb_i2c_master/uut/bit_count
add wave /tb_i2c_master/uut/data_rd
add wave /tb_i2c_master/uut/data_tx
add wave /tb_i2c_master/uut/sda_int
add wave /tb_i2c_master/uut/addr_rnw


#i2c bus
add wave -divider i2c_bus
add wave /tb_i2c_master/uut/sda
add wave /tb_i2c_master/uut/scl




#Setup of the wave window
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 0} {500 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 280
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2000 ns}


