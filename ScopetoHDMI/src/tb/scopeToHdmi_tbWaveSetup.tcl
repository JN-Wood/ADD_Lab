restart
remove_wave [get_waves *]

<<<<<<< Updated upstream
# can anyone find a single command to delete all the waves with one command?
# otherwise you need to manually delete all the waves every
# time you run a simulation.

add_wave  -color green /scopeToHdmi_tb/clk_t
add_wave  -color green /scopeToHdmi_tb/resetn_t

add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/vsg/h_cnt
add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/vsg/pixelHorz
add_wave   -color yellow 		/scopeToHdmi_tb/vsg/h_activeArea
add_wave   -color yellow 		/scopeToHdmi_tb/vsg/hs

add_wave   -color orange -radix unsigned /scopeToHdmi_tb/vsg/v_cnt
add_wave   -color yellow -radix unsigned /scopeToHdmi_tb/vsg/pixelVert
add_wave   -color orange 		/scopeToHdmi_tb/vsg/v_activeArea
add_wave   -color orange		/scopeToHdmi_tb/vsg/vs

add_wave   -color aqua	 		/scopeToHdmi_tb/vsg/de

add_wave   -color red -radix hex	/scopeToHdmi_tb/sf/red
add_wave   -color green -radix hex	/scopeToHdmi_tb/sf/green
add_wave   -color blue -radix hex	/scopeToHdmi_tb/sf/blue


=======
# Testbench-level signals
add_wave  -color green /scopeToHdmi_tb/clk_t
add_wave  -color green /scopeToHdmi_tb/resetn_t
>>>>>>> Stashed changes

# Clock wizard outputs (vsg and sf run on videoClk)
add_wave  -color green /scopeToHdmi_tb/uut/videoClk
add_wave  -color green /scopeToHdmi_tb/uut/clkLocked

# Horizontal timing
add_wave  -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/h_cnt
add_wave  -color yellow -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelHorz
add_wave  -color yellow                 /scopeToHdmi_tb/uut/vsg/h_activeArea
add_wave  -color yellow                 /scopeToHdmi_tb/uut/vsg/hs

# Vertical timing
add_wave  -color orange -radix unsigned /scopeToHdmi_tb/uut/vsg/v_cnt
add_wave  -color orange -radix unsigned /scopeToHdmi_tb/uut/vsg/pixelVert
add_wave  -color orange                 /scopeToHdmi_tb/uut/vsg/v_activeArea
add_wave  -color orange                 /scopeToHdmi_tb/uut/vsg/vs

add_wave  -color aqua                   /scopeToHdmi_tb/uut/vsg/de

# Pixel colors
add_wave  -color red   -radix hex /scopeToHdmi_tb/uut/sf/red
add_wave  -color green -radix hex /scopeToHdmi_tb/uut/sf/green
add_wave  -color blue  -radix hex /scopeToHdmi_tb/uut/sf/blue