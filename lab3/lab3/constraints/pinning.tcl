
#Toggle switches
set_location_assignment PIN_AA23 -to SW[0]
set_location_assignment PIN_AB26 -to SW[1]
#set_location_assignment PIN_AB25 -to SW[2]
#set_location_assignment PIN_AC27 -to SW[3]
#set_location_assignment PIN_AC26 -to SW[4]
#set_location_assignment PIN_AC24 -to SW[5]
#set_location_assignment PIN_AC23 -to SW[6]
#set_location_assignment PIN_AD25 -to SW[7]
#set_location_assignment PIN_AD24 -to SW[8]
#set_location_assignment PIN_AE27 -to SW[9]
#set_location_assignment PIN_W5 -to SW[10]
#set_location_assignment PIN_V10 -to SW[11]
#set_location_assignment PIN_U9 -to SW[12]
#set_location_assignment PIN_T9 -to SW[13]
#set_location_assignment PIN_L5 -to SW[14]
#set_location_assignment PIN_L4 -to SW[15]
#set_location_assignment PIN_L7 -to SW[16]
#set_location_assignment PIN_L8 -to SW[17]
#LED outputs
#Red LEDs
set_location_assignment PIN_AJ6 -to LEDR[0]
set_location_assignment PIN_AK5 -to LEDR[1]
set_location_assignment PIN_AJ5 -to LEDR[2]
set_location_assignment PIN_AJ4 -to LEDR[3]
set_location_assignment PIN_AK3 -to LEDR[4]
set_location_assignment PIN_AH4 -to LEDR[5]
set_location_assignment PIN_AJ3 -to LEDR[6]
set_location_assignment PIN_AJ2 -to LEDR[7]
set_location_assignment PIN_AH3 -to LEDR[8]
set_location_assignment PIN_AD14 -to LEDR[9]
set_location_assignment PIN_AC13 -to LEDR[10]
set_location_assignment PIN_AB13 -to LEDR[11]
set_location_assignment PIN_AC12 -to LEDR[12]
set_location_assignment PIN_AB12 -to LEDR[13]
set_location_assignment PIN_AC11 -to LEDR[14]
set_location_assignment PIN_AD9 -to LEDR[15]
#set_location_assignment PIN_AD8 -to LEDR[16]
#set_location_assignment PIN_AJ7 -to LEDR[17]

#50MHz clock
set_location_assignment PIN_AD15 -to clk

#External asynchronous inputs
#Push buttons for external reset and enable
set_location_assignment PIN_T29 -to areset_n
set_location_assignment PIN_T28 -to ext_wr_n
set_location_assignment PIN_U30 -to ext_rd_n

#I2C data and clock
set_location_assignment PIN_G27 -to sda
set_location_assignment PIN_G28 -to scl


#To avoid that the FPGA is driving an unintended value on pins that are not in use:
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
#Pin AD25 is default assigned for two purposes and must be set to regular IO after configuration.
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"





