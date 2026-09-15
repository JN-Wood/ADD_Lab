----------------------------------------------------------------------------------
--	Ascii art showing monitor and O'scope face
--				----------------------------------------|
--				|										|
--				|	|-------------------------------|	|
--				|	|(UL)					    (UR)|	|
--				|	|								|	|
--				|	|								|	|
--				|	|								|	|
--				|	|								|	|
--				|	|								|	|
--				|	|(LL)					    (LR)|	|
--				|	|-------------------------------|	|
--				|										|
--				|										|
--				----------------------------------------|
--
--				UL = Upper Left = xx, yy	I'd suggest 
--				UR = Upper Right = xx,yy
--				LL = Lower Left = xx,yy
--				LR = Lower Right = xx,yy
--				Total scope display is X x Y
--				There are 10 major horiziontal divisions (xxx pixels between divisions)	
--					Each division will have 5 hatch marks (xx pixels between hatches)
--				There are 10 major vertcal divisions (xxx pixels between divisions)
--					Each division will have 5 hatch marks (xx pixels between hatches)
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

package scopeToHdmi_package is


    constant VIDEO_WIDTH_IN_BITS: NATURAL := 11;        -- 1650 "pixels" wide, this include FP, SYNCH and BP

    constant H_ACTIVE : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0) := std_logic_vector(to_unsigned(1280, VIDEO_WIDTH_IN_BITS));
    constant H_FP : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0) := 
    constant H_SYNC 
    constant H_BP 
    constant H_TOTAL : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0) := H_ACTIVE + H_FP + H_SYNC + H_BP;

    constant V_ACTIVE 
    constant V_FP 	
    constant V_SYNC 
    constant V_BP	
    constant V_TOTAL 
        
    constant L_EDGE 
    constant R_EDGE 
    constant WIDTH 

    constant T_EDGE 
    constant B_EDGE 
    constant HEIGHT 
	
    -- This is actually half of the width
    constant BORDER_LINE_WIDTH 

	-- RGB color values
    constant BORDER_R : STD_LOGIC_VECTOR(7 downto 0) := X"FF";
    constant BORDER_G : STD_LOGIC_VECTOR(7 downto 0) := X"FF";
    constant BORDER_B : STD_LOGIC_VECTOR(7 downto 0) := X"FF";

    constant GRID_R 
    constant GRID_G 
    constant GRID_B 

    constant CH1_R 
    constant CH1_G
    constant CH1_B 

    constant CH2_R
    constant CH2_G
    constant CH2_B

    constant TRIGGER_R 
    constant TRIGGER_G 
    constant TRIGGER_B 


component videoSignalGenerator is
    PORT(	clk: in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         hs: out STD_LOGIC;
         vs: out STD_LOGIC;
         de: out STD_LOGIC;
         pixelHorz: out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0);
         pixelVert: out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS-1 downto 0));
end component;

component scopeFace is
    PORT ( 	);
end component;

component clk_wiz_0 is
    PORT( 
        clk_out1: out STD_LOGIC;
        clk_out2: out STD_LOGIC;
        resetn: in STD_LOGIC;
        locked: out STD_LOGIC;
        clk_in1: in STD_LOGIC);
end component;


component hdmi_tx_0 is
    PORT (
        pix_clk: in STD_LOGIC;
        pix_clkx5: in STD_LOGIC;           
        pix_clk_locked: in STD_LOGIC;       
        rst: in STD_LOGIC;                  
        red : in STD_LOGIC_VECTOR(7 downto 0);
        green : in STD_LOGIC_VECTOR(7 downto 0);
        blue : in STD_LOGIC_VECTOR(7 downto 0);
        hsync: in STD_LOGIC;
        vsync: in STD_LOGIC;
        vde: in STD_LOGIC;
        aux0_din: in STD_LOGIC_VECTOR(3 downto 0);
        aux1_din: in STD_LOGIC_VECTOR(3 downto 0);
        aux2_din: in STD_LOGIC_VECTOR(3 downto 0);
        ade: in STD_LOGIC;            
        TMDS_CLK_P: out STD_LOGIC;
        TMDS_CLK_N: out STD_LOGIC;
        TMDS_DATA_P: out STD_LOGIC_VECTOR(2 downto 0);
        TMDS_DATA_N: out STD_LOGIC_VECTOR(2 downto 0));
end component;

component scopeToHdmi is
    PORT ( );
end component;
     
        	
end package;


