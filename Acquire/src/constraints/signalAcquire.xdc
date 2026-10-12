set_property PACKAGE_PIN U18 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports clk]

set_property PACKAGE_PIN N15 [get_ports resetn]
set_property IOSTANDARD LVCMOS33 [get_ports resetn]

set_property PACKAGE_PIN M14 [get_ports reg0Magnitude[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg0Magnitude[0]]

set_property PACKAGE_PIN R17 [get_ports btn[0]]
set_property IOSTANDARD LVCMOS33 [get_ports btn[0]]


set_property PACKAGE_PIN R14 [get_ports an7606convst]
set_property IOSTANDARD LVCMOS33 [get_ports an7606convst]


set_property PACKAGE_PIN W18 [get_ports an7606od[0]]
set_property IOSTANDARD LVCMOS33 [get_ports an7606od[0]]


set_property PACKAGE_PIN U15 [get_ports an7606data[0]]
set_property IOSTANDARD LVCMOS33 [get_ports an7606data[0]]


set_property PACKAGE_PIN T12 [get_ports an7606data[15]]
set_property IOSTANDARD LVCMOS33 [get_ports an7606data[15]]


