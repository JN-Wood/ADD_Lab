#################################################################################
# The simulator TCL starts in: C:/Users/coulston/AppData/Roaming/Xilinx/Vivado
# First step is to change directories.  Do this in the TCL command window. 
# Note you need to replace the Windows "\" with Unix "/"
# cd C:/Users/coulston/Dropbox/Mycourses/EENG484/VHDL_fall2025/enhancedPwm
# source pwm_tbWaveSetup.tcl
#################################################################################
relaunch_sim
restart
remove_wave [get_waves *]

add_wave  -color green /enhancedPwm_tb/uut/clk
add_wave  -color green /enhancedPwm_tb/uut/resetn

add_wave  -color blue /enhancedPwm_tb/uut/enb

add_wave   -color gold	-radix unsigned /enhancedPwm_tb/uut/pwmSignal
add_wave   -color gold	-radix unsigned /enhancedPwm_tb/uut/rollOver

add_wave   -color purple	-radix unsigned /enhancedPwm_tb/uut/PwmCount
add_wave   -color purple	-radix unsigned /enhancedPwm_tb/uut/dutyCycle

add_wave   -color red			/enhancedPwm_tb/uut/E255
add_wave   -color red			/enhancedPwm_tb/uut/dutyGreaterCnt
add_wave   -color red			/enhancedPwm_tb/uut/counterControl














