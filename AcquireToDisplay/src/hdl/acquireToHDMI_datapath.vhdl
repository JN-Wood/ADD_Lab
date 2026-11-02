--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- Modified:	Sept 2022
-- File:	acquireToHDMI_Datapath.vhdl
-- HW:		Lab 3
-- Crs:		ECE 383 and EENG 484
--
-- Purp: The complete datapath for the audio O'scope
--
-- Documentation:	No help
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.acquireToHDMI_Package.all;			
use work.basicBuildingBlocks_package.all;		
use work.scopeToHDMI_Package.all;

entity acquireToHDMI_datapath is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   cw : in STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
		   sw : out STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);

           triggerVolt16bitSigned: in SIGNED(15 downto 0);
		   triggerTimePixel: in STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
		   ch1Data16bitSLV, ch2Data16bitSLV: out STD_LOGIC_VECTOR(15 downto 0);
		   
		   tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
           tmdsClkP : out STD_LOGIC;
           tmdsClkN : out STD_LOGIC;
           hdmiOen:    out STD_LOGIC
		   );
end acquireToHDMI_datapath;

architecture behavior of acquireToHDMI_datapath is

    signal storeIntoBramFlag: STD_LOGIC;
    signal videoClk: STD_LOGIC;
    signal videoClk5x: STD_LOGIC;
    signal clkLocked: STD_LOGIC;
    signal pixelH: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
    signal pixelV: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);

    signal hs_internal: STD_LOGIC;
    signal vs_internal: STD_LOGIC;
    signal vde_internal: STD_LOGIC;
    signal red_internal: STD_LOGIC_VECTOR(7 downto 0);
    signal green_internal: STD_LOGIC_VECTOR(7 downto 0);
    signal blue_internal: STD_LOGIC_VECTOR(7 downto 0);
    signal ch1_internal: STD_LOGIC_VECTOR(15 downto 0);
    signal ch2_internal: STD_LOGIC_VECTOR(15 downto 0);

    signal signedBRAM1Out: STD_LOGIC_VECTOR(15 downto 0);
    signal signedBRAM2Out: STD_LOGIC_VECTOR(15 downto 0);

    signal ch1PixelVal: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal ch2PixelVal: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal ch1: STD_LOGIC;
    signal ch2: STD_LOGIC;

    signal ch1Data16bitSignedSLV: STD_LOGIC_VECTOR(15 downto 0);
    signal ch2Data16bitSignedSLV: STD_LOGIC_VECTOR(15 downto 0);
    signal ch1GreaterThan: STD_LOGIC;
    signal ch2GreaterThan: STD_LOGIC;

    signal longDelayCounterOut: STD_LOGIC_VECTOR(LONG_DELAY_50Mhz_CONST_WIDTH - 1 downto 0);
	signal shortDelayCounterOut: STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0);	
    signal sampleCounterOut :STD_LOGIC_VECTOR(31 downto 0);
    signal sampleMuxOut: STD_LOGIC_VECTOR(31 downto 0);
begin

-- video section
    videoSigGen: videoSignalGenerator
        PORT MAP (
            clk => videoClk,
            resetn => resetn,
            pixelH => pixelH,
            pixelV => pixelV,
            hs => hs_internal,
            vs => vs_internal,
            vde => vde_internal,
        );

    face: scopeFace
        PORT MAP (
            clk => videoClk, 
            resetn => resetn,
            pixelHorz =>pixelH,
            pixelVert pixelV,
            triggerVolt => trigVscr,
            triggerTime => trigTimePixel,
            red => red_internal,
            green => green_internal,
            blue => blue_internal,
            ch1 => ch1_internal,
            ch1Enb => '1';
            ch2 => ch2_internal,
            ch2Enb => '1',
        );

    -- need to create clk and clk5x for HDMI transmitter
    hdmi_inst: hdmi_tx_0
        PORT MAP (
            pix_clk        => videoClk,	
            pix_clkx5      => videoClk5x,           
            pix_clk_locked => clkLocked,       
            rst            => reset,                  
            red            => red_internal,
            green          => green_internal,
            blue           => blue_internal,
            hsync          => hs_internal,
            vsync          => vs_internal,
            vde            => vde_internal,
            aux0_din       => "0000",
            aux1_din       => "0000",
            aux2_din       => "0000",
            ade            => '0',            
            TMDS_CLK_P     => tmdsClkP,
            TMDS_CLK_N     => tmdsClkN,
            TMDS_DATA_P    => tmdsDataP,
            TMDS_DATA_N    => tmdsDataN
        );
        
--bram section
    addressCounter: genericCounter
		generic Map(16)
		port Map(	
            clk => clk,
			resetn => resetn,
			c => cw(DATA_STORAGE_COUNTER_1_CW_BIT_1_INDEX downto DATA_STORAGE_COUNTER_1_CW_BIT_0_INDEX),
			q => wrAddr,
			d => (others <= '0')
    	);

    addressCompare: genericCompare
        generic Map(16)
        port Map(  
            x => WIDTH,
            y => wrAddr,
            e => open,
            l => open,
            g => sw(FULL_SW_BIT_INDEX)
        );

    ch1BRAM: blk_mem_gen_0
        port Map(
            clka => clk,
            ena => '1',
            wea => cw(TRIG_CH1_WRITE_CW_BIT_INDEX),
            addra => wrAddr,
            dina => an7606data,
            clkb => videoClk,
            enb  => '1',
            addrb => pixelH-L_EDGE,
            doutb => ch1Signed
        );

    ch2BRAM: blk_mem_gen_0
        port Map(
            clka => clk,
            ena => '1',
            wea => cw(TRIG_CH2_WRITE_CW_BIT_INDEX),
            addra => wrAddr,
            dina => an7606data,
            clkb => videoClk,
            enb  => '1',
            addrb => pixelH-L_EDGE,
            doutb => ch2Signed
        );

    ch1Pixel: signedToPixel:
        port Map(
            signedIn => ch1Signed,
            pixelOut => ch1PixelVal
        );
        
    ch2Pixel: signedToPixel:
        port Map(
            signedIn => ch2Signed,
            pixelOut => ch2PixelVal
        );
    
    ch1Compare: genericCompare
        generic Map(VIDEO_WIDTH_IN_BITS)
        port Map(
            x => ch1PixelVal
            y => pixelV,
            g => open,
            l => open, 
            e => ch1,
        );
        
    ch2Compare: genericCompare
        generic Map(VIDEO_WIDTH_IN_BITS)
        port Map(
            x => ch2PixelVal
            y => pixelV,
            g => open,
            l => open, 
            e => ch2
        );

-- CH1 Trigger Detection
    prevReg: genericRegister
        generic Map(16)
        port Map(
            clk => clk,
            resetn => resetn,
            d => ch1,
            q => ch1Data16bitSignedSLV
        );




    -- Simple SR Latch to assist FSM
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(resetn ='0') then
                storeIntoBramFlag <= '0';
            elsif (cw(SET_STORE_FLAG_CW_BIT_INDEX) = '1') then
                storeIntoBramFlag <= '1';
            elsif (cw(CLEAR_STORE_FLAG_CW_BIT_INDEX) = '1') then
                storeIntoBramFlag <= '0';
            end if;
        end if;
    end process;
    sw(STORE_SW_BIT_INDEX) <= storeIntoBramFlag;
    
    -- Video clk
    vc: clk_wiz_0
        PORT MAP (
            clk_in1 => clk,
            clk_out1 => videoClk,
            resetn => resetn,
            clk_out2 => videoClk5x);

    --Long delay counter instantiation
	longDelayCounter: genericCounter
		generic Map(LONG_DELAY_50Mhz_CONST_WIDTH)
		port Map(	
            clk => clk,
			resetn => resetn,
			c => cw(LONG_COUNT_CW_BIT_1_INDEX downto LONG_COUNT_CW_BIT_0_INDEX),
			q => longDelayCounterOut,
			d => x"000000"
	    );

	--Short delay counter instantiation
	shortDelayCounter: genericCounter
		generic Map(SHORT_DELAY_50Mhz_CONST_WIDTH)
		port Map(	
            clk => clk,
			resetn => resetn,
			c => cw(SHORT_COUNT_CW_BIT_1_INDEX downto SHORT_COUNT_CW_BIT_0_INDEX),
			q => shortDelayCounterOut,
			d => x"00"
	    );

	-- Long delay comparator instantiation
	longDelayComparator: genericCompare
		generic Map(LONG_DELAY_50Mhz_CONST_WIDTH)
		port Map(	
            x => LONG_DELAY_50Mhz_COUNTS,
			y => longDelayCounterOut,
			g => open,
			l => open,
			e => sw(LONG_DELAY_DONE_SW_BIT_INDEX)
	    );

	-- Short delay comparator instantiation
	shortDelayComparator: genericCompare
		generic Map(SHORT_DELAY_50Mhz_CONST_WIDTH)
		port Map(	
            x => SHORT_DELAY_50Mhz_COUNTS,
			y => shortDelayCounterOut,
			g => open,
			l => open,
			e => sw(SHORT_DELAY_DONE_SW_BIT_INDEX)
	    );

    sampleCounter: genericCounter
        generic Map(32)
        port Map(
            clk => clk,
            resetn => resetn,
            c => cw(SAMPLING_COUNTER_1_CW_BIT_INDEX downto SAMPLING_COUNTER_0_CW_BIT_INDEX),
            q => sampleCounterOut,
            d => x"00000000"
        );

    sampleMux: genericMux4x1
        generic Map(32)
        port Map(
            y3 => HIGHEST_RATE,
            y2 => HIGH_RATE,
            y1 => LOW_RATE,
            y0 => LOWEST_RATE,
            s => cw(SAMPLING_RATE_SELECT_1_CW_BIT_INDEX downto SAMPLING_RATE_SELECT_0_CW_BIT_INDEX),
            f => sampleMuxOut
        );

    sampleCompare: genericCompare
        generic Map(32)
        port Map(
            x => sampleCounterOut,
            y => sampleMuxOut,
            g => open,
            l => open,
            e => sw(SAMPLE_SW_BIT_INDEX)
        );

end behavior;
