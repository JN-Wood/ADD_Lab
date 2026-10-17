restart
remove_wave [get_waves *]

# Top-Level Ports
add_wave  -color green  /signalAcquire_tb/uut/clk
add_wave  -color green  /signalAcquire_tb/uut/resetn
add_wave  -color yellow /signalAcquire_tb/uut/btn

# State & Datapath Counters
add_wave  -color aqua   /signalAcquire_tb/uut/fsm/state
add_wave  -color purple -radix unsigned /signalAcquire_tb/uut/Datapath/shortDelayCounter
add_wave  -color purple -radix unsigned /signalAcquire_tb/uut/Datapath/longDelayCounter
add_wave  -color purple -radix unsigned /signalAcquire_tb/uut/Datapath/regCount

# ADC Interface Signals
add_wave  -color orange -radix hex /signalAcquire_tb/uut/an7606data
add_wave  -color orange /signalAcquire_tb/uut/an7606convst
add_wave  -color orange /signalAcquire_tb/uut/an7606cs
add_wave  -color orange /signalAcquire_tb/uut/an7606rd
add_wave  -color orange /signalAcquire_tb/uut/an7606reset
add_wave  -color orange /signalAcquire_tb/uut/an7606busy

# Control & Status Words
add_wave  -color red    -radix hex /signalAcquire_tb/uut/cw
add_wave  -color maroon -radix hex /signalAcquire_tb/uut/sw
add_wave  -color maroon -radix hex -name Trigger /signalAcquire_tb/uut/sw[3]

# AD Sample Registers
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q0
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q1
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q2
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q3
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q4
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q5
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q6
add_wave  -color gold   -radix hex /signalAcquire_tb/uut/Datapath/regFile/Q7