----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use work.scopeToHdmi_package.all;

entity scopeToHdmi is
    PORT ( sysClk : in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         btn: in	STD_LOGIC_VECTOR(2 downto 0);
         tmdsDataP : out  STD_LOGIC_VECTOR (2 downto 0);
         tmdsDataN : out  STD_LOGIC_VECTOR (2 downto 0);
         tmdsClkP : out STD_LOGIC;
         tmdsClkN : out STD_LOGIC;
         hdmiOen:    out STD_LOGIC);
end scopeToHdmi;


architecture structure of scopeToHdmi is

    
    
    signal triggerTime, triggerVolt: STD_LOGIC_VECTOR((VIDEO_WIDTH_IN_BITS - 1) downto 0);
    signal pixelHorz, pixelVert: STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
	    
    signal ch1Wave, ch2Wave: STD_LOGIC;

    signal videoClk, videoClk5x, clkLocked: STD_LOGIC;
    
    
    -- the following connects VideoSignalGenerator to hdmi_tx_0
    signal hsync_internal, vsync_internal, vde_internal: std_logic;
    -- the following connects scopeFace to hdmi_tx_0
    signal red_internal, green_internal, blue_internal: STD_LOGIC_VECTOR(7 downto 0);
    --signals used to output hdmi
    signal tmdsDataP_internal , tmdsDataN_internal:STD_LOGIC_VECTOR(2 downto 0);
    signal tmdsClkP_internal,tmdsClkN_internal : std_logic;
    signal reset: std_logic;
    
    signal prevButton, currButton, activeButton: std_logic_vector (2 downto 0);

begin
    

    vsg: videoSignalGenerator
        PORT MAP (  clk => videoClk, 
                    resetn => resetn,
                    pixelHorz => pixelHorz,
                    pixelVert => pixelVert,
                    hs => hsync_internal,
                    vs => vsync_internal,
                    de => vde_internal);

    sf: scopeFace
        PORT MAP (clk => videoClk,
                 resetn => resetn,
                 pixelHorz  => pixelHorz,
                 pixelVert  => pixelVert,
                 triggerVolt => triggerVolt,
                 triggerTime => triggerTime,
                 red => red_internal,
                 green => green_internal,
                 blue => blue_internal,
                 ch1 => ch1Wave,
                 ch1Enb => '1',
                 ch2 => ch2Wave,
                 ch2Enb => '1');
                 

    hdmi_inst: hdmi_tx_0
        PORT MAP (
            pix_clk        => videoClk,	
            pix_clkx5      => videoClk5x,           
            pix_clk_locked => clkLocked,       
            rst            => reset,                  
            red            => red_internal,
            green          => green_internal,
            blue           => blue_internal,
            hsync          => hsync_internal,
            vsync          => vsync_internal,
            vde            => vde_internal,
            aux0_din       => "0000",
            aux1_din       => "0000",
            aux2_din       => "0000",
            ade            => '0',            
            TMDS_CLK_P     => tmdsClkP,
            TMDS_CLK_N     => tmdsClkN,
            TMDS_DATA_P    => tmdsDataP,
            TMDS_DATA_N    => tmdsDataN);
            

    vc: clk_wiz_0
	PORT MAP( 
	    clk_out1 => videoClk,
	    clk_out2 => videoClk5x,
	    resetn => resetn,
	    locked => clkLocked,
	    clk_in1 => sysClk);

    ------------------------------------------------------------------------------
    -- Create a process which generates a 3-bit vector which shows if button
    -- has change state.  Use this change vector to determine if you should 
    -- increment/decrement the triggerTime or triggerVolt values
    ------------------------------------------------------------------------------
    -- TT for buttons:
    -- prevButton, currButton, activeButton
    --process(sysClk) -- should hold the current state and previous state of the buttons
    --begin
    --if resetn = '0' then
    --    activeButton <= (others => '1');
    --    currButton <=(others => '1');
    --    activeButton <= (others => '1');
    --    -- todo set center value for contage and time triggers 
    --else 
    --    currButton <= btn; 
    --    activeButton <= prevButton xor currButton; -- bitwise XOR to see if buttons changed 
    --    prevButton <= currButton; 
    --    
    --end if;
    ---- resetn should reset to default value
    --end process;
    --    
    --process(sysClk)
    --begin
    --if (activeButton = "010") then 
    --        triggerVolt <= triggerVolt-10; -- each result is input buttons xored with 111
    --    elsif (activeButton = "110") then 
    --        triggerVolt <= triggerVolt+10;
    --    elsif (activeButton = "110") then 
    --        triggerTime <= triggerTime-10;
    --    elsif (activeButton = "010") then 
    --        triggerTime <= triggerTime+10;
    --    end if;
    --end process;
    
    reset <= not resetn;
    ch1Wave <= '1' when  (pixelHorz = pixelVert and (pixelHorz >L_EDGE and pixelVert >T_EDGE) and (pixelHorz < R_EDGE and pixelVert < B_EDGE)) else '0';
    ch2Wave <= '1' when  (pixelVert = triggerVolt(pixelHorz >L_EDGE and pixelVert >T_EDGE) and (pixelHorz < R_EDGE and pixelVert < B_EDGE)) else '0';
    
    tmdsDataP <= tmdsDataP_internal;
    tmdsDataN <= tmdsDataN_internal;
    tmdsClkP <= tmdsClkP_internal;
    tmdsClkN <= tmdsClkN_internal;
    hdmiOen <= '1';

    triggerVolt <= STD_LOGIC_VECTOR(TO_UNSIGNED(200, VIDEO_WIDTH_IN_BITS));
    triggerTime <= STD_LOGIC_VECTOR(TO_UNSIGNED(200, VIDEO_WIDTH_IN_BITS));

    
end structure;
