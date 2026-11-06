restart
remove_wave -quiet [get_waves *]

add_wave -color green /acquireToHDMI_tb/uut/clk
add_wave -color green /acquireToHDMI_tb/uut/resetn

set groupColor YELLOW
set TOP_ID [add_wave_group "topLevelIO"]
add_wave -into $TOP_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/btn
add_wave -into $TOP_ID -color $groupColor /acquireToHDMI_tb/uut/triggerCh1
add_wave -into $TOP_ID -color $groupColor -radix hex /acquireToHDMI_tb/uut/datapath_inst/ch1Data16bitSignedSLV
add_wave -into $TOP_ID -color $groupColor -radix hex /acquireToHDMI_tb/uut/datapath_inst/ch1Previous
add_wave -into $TOP_ID -color $groupColor /acquireToHDMI_tb/uut/datapath_inst/ch1GreaterThan
add_wave -into $TOP_ID -color $groupColor /acquireToHDMI_tb/uut/datapath_inst/ch1LessThan
add_wave -into $TOP_ID -color $groupColor /acquireToHDMI_tb/uut/conversionPlusReadoutTime
add_wave -into $TOP_ID -color $groupColor /acquireToHDMI_tb/uut/sampleTimerRollover

add_wave   -color aqua /acquireToHDMI_tb/uut/control_inst/state

set groupColor PURPLE
set COUNT_ID [add_wave_group "Counters"]
# Add sample rate counter
add_wave -into $COUNT_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/shortDelayCounterOut
add_wave -into $COUNT_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/longDelayCounterOut
add_wave -into $COUNT_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/sampleCounterOut

set groupColor ORANGE
set AD7606_ID [add_wave_group "AD7606 Interface"]
add_wave -into $AD7606_ID -color $groupColor /acquireToHDMI_tb/uut/an7606reset
add_wave -into $AD7606_ID -color $groupColor /acquireToHDMI_tb/uut/an7606convst
add_wave -into $AD7606_ID -color $groupColor /acquireToHDMI_tb/uut/an7606cs
add_wave -into $AD7606_ID -color $groupColor /acquireToHDMI_tb/uut/an7606rd
add_wave -into $AD7606_ID -color $groupColor /acquireToHDMI_tb/uut/an7606busy
add_wave -into $AD7606_ID -color $groupColor -radix hex	/acquireToHDMI_tb/uut/an7606data

set groupColor YELLOW
set BRAM_ID [add_wave_group "BRAM Interface"]
add_wave -into $BRAM_ID -color $groupColor -radix unsigned -name "Ch1 Write Address" /acquireToHDMI_tb/uut/datapath_inst/wrAddr
add_wave -into $BRAM_ID -color $groupColor -radix hex      -name "Ch1 Read Address"  /acquireToHDMI_tb/uut/datapath_inst/addrB
add_wave -into $BRAM_ID -color $groupColor -radix hex      -name "Ch1 Data In"       /acquireToHDMI_tb/uut/datapath_inst/an7606data
add_wave -into $BRAM_ID -color $groupColor -radix hex      -name "Ch1 Data Out"      /acquireToHDMI_tb/uut/datapath_inst/ch1Signed
add_wave -into $BRAM_ID -color $groupColor                 -name "Ch1 Write Enable"  /acquireToHDMI_tb/uut/datapath_inst/ch1BRAM/wea

set groupColor BLUE
set HDMI_ID [add_wave_group "Video Interface"]
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/videoSigGen/h_cnt
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/pixelH
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/hs_internal
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/videoSigGen/v_cnt
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/pixelV
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/vs_internal
add_wave -into $HDMI_ID -color $groupColor -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/vde_internal
add_wave -into $HDMI_ID -color red -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/red_internal
add_wave -into $HDMI_ID -color green -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/green_internal
add_wave -into $HDMI_ID -color blue -radix unsigned /acquireToHDMI_tb/uut/datapath_inst/blue_internal

set groupColor MAROON
set SW_ID [add_wave_group "Status Word"]
add_wave -into $SW_ID -color $groupColor -name "FORCED MODE" 		/acquireToHDMI_tb/uut/sw[9]

set groupColor LIME
set CW_ID [add_wave_group "Control Word"]
add_wave -into $CW_ID -color $groupColor -name "CLEAR STORE FLAG" /acquireToHDMI_tb/uut/cw[21]
add_wave -into $CW_ID -color $groupColor -name "SET STORE FLAG" /acquireToHDMI_tb/uut/cw[20]

set FORCED_CHECK01        500ns   
set FORCED_CHECK02      700000ns  
set FORCED_CHECK03    1311500ns   
set FORCED_CHECK04    1340000ns   
set FORCED_CHECK05    2900000ns   
set FORCED_CHECK06    7360000ns   

set FORCED_T01toT02    699500ns
set FORCED_T02toT03    611500ns
set FORCED_T03toT04     28500ns
set FORCED_T04toT05   1560000ns
set FORCED_T05toT06   4460000ns

set TRIGGER_CHECK01        500ns  
set TRIGGER_CHECK02    1311200ns  
set TRIGGER_CHECK03    1413820ns 
set TRIGGER_CHECK04    7455000ns

set TRIGGER_T01toT02   1310700ns
set TRIGGER_T02toT03    102620ns
set TRIGGER_T03toT04   6041180ns