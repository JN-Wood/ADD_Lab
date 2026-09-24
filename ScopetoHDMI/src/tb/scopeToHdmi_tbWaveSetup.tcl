restart
remove_wave [get_waves *]

add_wave -color green /scopeToHdmi_tb/clk_t
add_wave -color green /scopeToHdmi_tb/resetn_t

add_wave -color green /scopeToHdmi_tb/uut/videoClk
add_wave -color green /scopeToHdmi_tb/uut/clkLocked

add_wave -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/h_cnt
add_wave -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelHorz
add_wave -color yellow /scopeToHdmi_tb/uut/vsg/h_activeArea
add_wave -color yellow /scopeToHdmi_tb/uut/vsg/hs


add_wave -color orange -radix unsigned /scopeToHdmi_tb/uut/vsg/v_cnt
add_wave -color orange -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelVert
add_wave -color orange /scopeToHdmi_tb/uut/vsg/v_activeArea
add_wave -color orange /scopeToHdmi_tb/uut/vsg/vs
add_wave -color aqua /scopeToHdmi_tb/uut/vsg/de


add_wave -color red -radix hex /scopeToHdmi_tb/uut/sf/red
add_wave -color green -radix hex /scopeToHdmi_tb/uut/sf/green
add_wave -color blue -radix hex /scopeToHdmi_tb/uut/sf/blue

