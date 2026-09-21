----------------------------------------------------------------------------------
-- Include proper comment header block
-- ***Do not use mod operator in this code***
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.scopeToHdmi_package.all;

entity scopeFace is
    PORT ( 	clk: in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         pixelHorz : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
         pixelVert : in  STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS -1 downto 0);
         triggerVolt: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         triggerTime: in STD_LOGIC_VECTOR (VIDEO_WIDTH_IN_BITS - 1 downto 0);
         red : out  STD_LOGIC_VECTOR(7 downto 0);
         green : out  STD_LOGIC_VECTOR(7 downto 0);
         blue : out  STD_LOGIC_VECTOR(7 downto 0);
         ch1: in STD_LOGIC;
         ch1Enb: in STD_LOGIC;
         ch2: in STD_LOGIC;
         ch2Enb: in STD_LOGIC);
end scopeFace;


architecture Behavioral of scopeFace is

    -- Set these signals to '1' when the features should be drawn at the current pixelHorz, pixelVert 
    -- cordinate.  These act like Feature Booleans which you will use in the process(clk) to set the 
    -- correct RGB for this pixel location. Finish and add more.
    
    signal borderTop, borderBottom, borderLeft, borderRight : STD_LOGIC;
    

begin


    ---------------------------------------------------------------------
    -- Use the Feature Booleans to set the RGB at this pixel location.
    -- The waveforms should sit "on top" of the grid.
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                red <= (others => '0');
                green <= (others => '0');
                blue <= (others => '0');
            else
                if ((borderTop = '1') or (borderBottom = '1') or (borderLeft = '1') or (borderRight = '1')) then
                    red <= BORDER_R;
                    green <= BORDER_G;
                    blue <= BORDER_B;
                elsif 

                    <add elsif for each Feature Boolean>
              
                else
                    red <= X"00";
                    green <= X"00";
                    blue <= X"00";
                end if;
            end if;
        end if;
    end process;    


    -- Generate Borders

    borderTop <=   '1' when    ((pixelVert < T_EDGE-BORDER_LINE_WIDTH) and (pixelVert > T_EDGE + BORDER_LINE_WIDTH) and 
                            (pixelH > L_EDGE- BORDER_LINE_WIDTH) and (pixelH < R_EDGE+BORDER_LINE_WIDTH)) else
                            '0';
    borderBottom <= 1' when    ((pixelVert > B_EDGE - BORDER_LINE_WIDTH) and (pixelVert < B_EDGE + BORDER_LINE_WIDTH ) and
                            (pixelH > L_EDGE- BORDER_LINE_WIDTH) and (pixelH < R_EDGE+BORDER_LINE_WIDTH)) else
                            '0';
    borderLeft <=   '1' when    ((pixelH > L_EDGE - BORDER_LINE_WIDTH ) and (pixelH < L_EDGE + BORDER_LINE_WIDTH ) and
                            ( pixelVert > T_EDGE) and (pixelVert < B_EDGE)) else
                            '0';       
    borderRight <=  '1' when    ((pixelH > R_EDGE - BORDER_LINE_WIDTH) and (pixelH < R_EDGE + BORDER_LINE_WIDTH) and 
                            ( pixelVert > T_EDGE) and (pixelVert < B_EDGE)) else
                            '0';



end Behavioral;


