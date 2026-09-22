#################################################################################
#Simulator TCL starts in: C:/Users/Chris/AppData/Roaming/Xilinx/Vivado
# cd C:\Users\Chris\Dropbox\Mycourses\EENG498\VHDL\scopeToHdmi
# Note, you need to switch the direction of the slash from windows "/" to "\"
# source scopeToHdmi_tbWaveSetup.tcl
# Note your signal names will probablly be different, edit to make consistent
#################################################################################
restart

# can anyone find a single command to delete all the waves with one command?
# otherwise you need to manually delete all the waves every
# time you run a simulation.

add_wave  -color green /scopeToHdmi_tb/clk
add_wave  -color green /scopeToHdmi_tb/resetn

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







