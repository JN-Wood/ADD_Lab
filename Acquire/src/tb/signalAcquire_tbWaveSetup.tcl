#################################################################################
# Simulator starts in: C:/Users/Chris/AppData/Roaming/Xilinx/Vivado
# Add this file as a simulation source in Vivado and it will automatically 
# load when you start a simulation.
#################################################################################
restart
remove_wave [get_waves *]

add_wave  -color green /signalAcquire_tb/uut/clk
add_wave  -color green /signalAcquire_tb/uut/resetn
add_wave  -color yellow /signalAcquire_tb/uut/btn

add_wave   -color aqua /signalAcquire_tb/uut/control_inst/state
add_wave   -color purple	-radix unsigned /signalAcquire_tb/uut/datapath_inst/shortDelayCounter
add_wave   -color purple	-radix unsigned /signalAcquire_tb/uut/datapath_inst/longDelayCounter
add_wave   -color purple	-radix unsigned /signalAcquire_tb/uut/datapath_inst/regCounter

add_wave   -color orange -radix hex	/signalAcquire_tb/uut/an7606data
add_wave   -color orange 		/signalAcquire_tb/uut/an7606convst
add_wave   -color orange 		/signalAcquire_tb/uut/an7606cs
add_wave   -color orange 		/signalAcquire_tb/uut/an7606rd
add_wave   -color orange		/signalAcquire_tb/uut/an7606reset
add_wave   -color orange		/signalAcquire_tb/uut/an7606busy
add_wave   -color red -radix hex	/signalAcquire_tb/uut/cw
add_wave   -color maroon -radix hex	/signalAcquire_tb/uut/sw
add_wave   -color maroon -radix hex -name Trigger	/signalAcquire_tb/uut/sw[3]

add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q0
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q1
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q2
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q3
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q4
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q5
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q6
add_wave   -color gold -radix hex	/signalAcquire_tb/uut/datapath_inst/adSamples_inst/Q7




