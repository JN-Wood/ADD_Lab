--//////////Top Level for signal Acquisition /////////////////////////////--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.acquireToHDMI_package.all;					-- include your library here with added components ac97, ac97cmd
use work.scopeToHDMI_Package.all;					-- include your library here with added components ac97, ac97cmd
use work.basicBuildingBlocks_package.all;					-- include your library here with added components ac97, ac97cmd


entity acquireToHDMI is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   triggerCh1, triggerCh2: out STD_LOGIC;		   
		   conversionPlusReadoutTime: out STD_LOGIC;
		   sampleTimerRollover: out STD_LOGIC;
		   
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   
		   tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsClkP : out STD_LOGIC;
           tmdsClkN : out STD_LOGIC;
           hdmiOen:    out STD_LOGIC		   
		   );		   
end acquireToHDMI;

architecture behavior of acquireToHDMI is
    
    signal cw: STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
    signal sw: STD_LOGIC_VECTOR(SW_WIDTH -1 downto 0);
    signal forcedMode: STD_LOGIC;
    signal buttonActivity, prevBtn, currBtn: STD_LOGIC_VECTOR(2 downto 0);
    signal triggerPix: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
        	
begin

    conversionPlusReadoutTime <= cw(CONVERSION_PLUS_READOUT_CW_BIT_INDEX);
    sampleTimerRollover <= cw(SAMPLE_TIMER_ROLLOVER_CW_BIT_INDEX);
    
    an7606convst <= cw(CONVST_CW_BIT_INDEX);    
    an7606od <= "000"; 
    an7606reset <= cw(RESET_AD7606_CW_BIT_INDEX);
    an7606cs <= cw(CS_CW_BIT_INDEX);
    an7606rd <= cw(RD_CW_BIT_INDEX);
    sw(BUSY_SW_BIT_INDEX) <= an7606busy;

    ------------------------------------------------------------------------------
    -- Button Process
    ------------------------------------------------------------------------------
    --btn(0) is single
    --btn(1) is forced mode select 
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
               sw(FORCED_MODE_SW_BIT_INDEX downto SINGLE_SW_BIT_INDEX) <= "00";
               prevBtn <= "000";
            else
               currBtn <= btn;
               prevBtn <= currBtn;
            end if;
        end if;
        buttonActivity <= currBtn and not prevBtn;
        forcedMode <= buttonActivity(1) xor forcedMode; -- toggle forced mode on button press
    end process;

    
    sw(SINGLE_SW_BIT_INDEX) <= buttonActivity(0);
    sw(FORCED_MODE_SW_BIT_INDEX) <= forcedMode;
    triggerCh1 <= sw(CHANNEL_1_TRIG_SW_BIT_INDEX);
    triggerCh2 <= sw(CHANNEL_2_TRIG_SW_BIT_INDEX);
    
    triggerPix <= T_EDGE + std_logic_vector(shift_right(unsigned(HEIGHT), 1));
 	datapath_inst: acquireToHDMI_datapath 
        port Map(
            clk => clk,
            resetn => resetn,
            cw => cw(CW_WIDTH - 1 downto 0),
            sw => sw(DATAPATH_SW_WIDTH - 1 downto 0),
            an7606Data => an7606data,
            triggerVolt16bitSigned => (others => '0'), -- not used in this top level, can be connected to a signal if needed
            triggerTimePixel => triggerPix, 
            ch1Data16bitSLV => open,
            ch2Data16bitSLV => open,
            tmdsDataP => tmdsDataP,
            tmdsDataN => tmdsDataN,
            tmdsClkP => tmdsClkP,
            tmdsClkN => tmdsClkN,
            hdmiOen => hdmiOen
	);
                
	control_inst: acquireToHDMI_fsm 
	   PORT MAP ( 
            clk => clk,
            resetn => resetn,
            sw => sw,
            cw => cw);

end behavior;
