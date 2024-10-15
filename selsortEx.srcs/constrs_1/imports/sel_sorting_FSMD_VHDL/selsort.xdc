## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

##Buttons
set_property PACKAGE_PIN U18 [get_ports reset]
	set_property IOSTANDARD LVCMOS33 [get_ports reset]

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx]
	set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
	set_property IOSTANDARD LVCMOS33 [get_ports tx]


