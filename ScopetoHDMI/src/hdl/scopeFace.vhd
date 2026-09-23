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
    
    signal borderTop, borderBottom, borderLeft, borderRight, TickHorz, TickVert, LineHorz, LineVert, triggerTimeMarker, triggerVoltMarker : STD_LOGIC;
    

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
                elsif (TickHorz = '1') or (TickVert = '1') or (LineVert = '1') or (LineHorz = '1') then
                    red <= GRID_R;
                    green <= GRID_G;
                    blue <= GRID_B;
                elsif (triggerTimeMarker = '1' or triggerVoltMarker = '1') then
                    red <= TRIGGER_R;
                    green <= TRIGGER_G;
                    blue <= TRIGGER_B;
                elsif ch1 <= '1' then -- changed ch1Wave to ch1
                    red <= CH1_R;
                    green <= CH1_G;
                    blue <= CH1_B;
                elsif ch2 <= '1' then -- changed ch1Wave to ch1
                    red <= CH2_R;
                    green <= CH2_G;
                    blue <= CH2_B;
                else
                    red <= X"00";
                    green <= X"00";
                    blue <= X"00";
                end if;
            end if;
        end if;
    end process;    


    -- Generate Borders

    borderTop <=   '1' when    ((pixelVert > T_EDGE-BORDER_LINE_WIDTH) and (pixelVert < T_EDGE + BORDER_LINE_WIDTH) and 
                            (pixelHorz > L_EDGE- BORDER_LINE_WIDTH) and (pixelHorz < R_EDGE+BORDER_LINE_WIDTH)) else
                            '0';
    borderBottom <= 1' when    ((pixelVert > B_EDGE - BORDER_LINE_WIDTH) and (pixelVert < B_EDGE + BORDER_LINE_WIDTH ) and
                            (pixelHorz > L_EDGE- BORDER_LINE_WIDTH) and (pixelHorz < R_EDGE+BORDER_LINE_WIDTH)) else
                            '0';
    borderLeft <=   '1' when    ((pixelHorz > L_EDGE - BORDER_LINE_WIDTH ) and (pixelHors < L_EDGE + BORDER_LINE_WIDTH ) and
                            ( pixelVert > T_EDGE-BORDER_LINE_WIDTH) and (pixelVert < B_EDGE+BORDER_LINE_WIDTH)) else
                            '0';       
    borderRight <=  '1' when    ((pixelHorz > R_EDGE - BORDER_LINE_WIDTH) and (pixelHorz < R_EDGE + BORDER_LINE_WIDTH) and 
                            ( pixelVert > T_EDGE-BORDER_LINE_WIDTH) and (pixelVert < B_EDGE+BORDER_LINE_WIDTH)) else
                            '0';

    triggerVoltMarker <= '1' when (pixelHorz >= L_EDGE + BORDER_LINE_WIDTH) and 
                              (pixelHorz < L_EDGE + BORDER_LINE_WIDTH + TRIGGER_MARKER_HEIGHT) and 
                              (pixelVert >= (triggerVolt + T_EDGE + BORDER_LINE_WIDTH) - (TRIGGER_MARKER_WIDTH - (pixelHorz - (L_EDGE + BORDER_LINE_WIDTH)))) and 
                              (pixelVert <= (triggerVolt + T_EDGE + BORDER_LINE_WIDTH) + (TRIGGER_MARKER_WIDTH - (pixelHorz - (L_EDGE + BORDER_LINE_WIDTH)))) else
                        '0';

    triggerTimeMarker <= '1' when (pixelVert >= T_EDGE + BORDER_LINE_WIDTH) and 
                              (pixelVert < T_EDGE + BORDER_LINE_WIDTH + TRIGGER_MARKER_HEIGHT) and 
                              (pixelHorz >= (triggerTime + L_EDGE + BORDER_LINE_WIDTH) - (TRIGGER_MARKER_WIDTH - (pixelVert - (T_EDGE + BORDER_LINE_WIDTH)))) and 
                              (pixelHorz <= (triggerTime + L_EDGE + BORDER_LINE_WIDTH) + (TRIGGER_MARKER_WIDTH - (pixelVert - (T_EDGE + BORDER_LINE_WIDTH)))) else
                        '0';


      
    TickHorz <= '1' when 
        ((PixelHorz = 5 and pixelVert  = 49) or
        (PixelHorz = 5 and pixelVert  = 50) or
        (PixelHorz = 5 and pixelVert  = 51) or
        (PixelHorz = 10 and pixelVert  = 49) or
        (PixelHorz = 10 and pixelVert  = 50) or
        (PixelHorz = 10 and pixelVert  = 51) or
        (PixelHorz = 15 and pixelVert  = 49) or
        (PixelHorz = 15 and pixelVert  = 50) or
        (PixelHorz = 15 and pixelVert  = 51) or
        (PixelHorz = 20 and pixelVert  = 49) or
        (PixelHorz = 20 and pixelVert  = 50) or
        (PixelHorz = 20 and pixelVert  = 51) or
        (PixelHorz = 25 and pixelVert  = 49) or
        (PixelHorz = 25 and pixelVert  = 50) or
        (PixelHorz = 25 and pixelVert  = 51) or
        (PixelHorz = 30 and pixelVert  = 49) or
        (PixelHorz = 30 and pixelVert  = 50) or
        (PixelHorz = 30 and pixelVert  = 51) or
        (PixelHorz = 35 and pixelVert  = 49) or
        (PixelHorz = 35 and pixelVert  = 50) or
        (PixelHorz = 35 and pixelVert  = 51) or
        (PixelHorz = 40 and pixelVert  = 49) or
        (PixelHorz = 40 and pixelVert  = 50) or
        (PixelHorz = 40 and pixelVert  = 51) or
        (PixelHorz = 45 and pixelVert  = 49) or
        (PixelHorz = 45 and pixelVert  = 50) or
        (PixelHorz = 45 and pixelVert  = 51) or
        (PixelHorz = 50 and pixelVert  = 49) or
        (PixelHorz = 50 and pixelVert  = 50) or
        (PixelHorz = 50 and pixelVert  = 51) or
        (PixelHorz = 55 and pixelVert  = 49) or
        (PixelHorz = 55 and pixelVert  = 50) or
        (PixelHorz = 55 and pixelVert  = 51) or
        (PixelHorz = 60 and pixelVert  = 49) or
        (PixelHorz = 60 and pixelVert  = 50) or
        (PixelHorz = 60 and pixelVert  = 51) or
        (PixelHorz = 65 and pixelVert  = 49) or
        (PixelHorz = 65 and pixelVert  = 50) or
        (PixelHorz = 65 and pixelVert  = 51) or
        (PixelHorz = 70 and pixelVert  = 49) or
        (PixelHorz = 70 and pixelVert  = 50) or
        (PixelHorz = 70 and pixelVert  = 51) or
        (PixelHorz = 75 and pixelVert  = 49) or
        (PixelHorz = 75 and pixelVert  = 50) or
        (PixelHorz = 75 and pixelVert  = 51) or
        (PixelHorz = 80 and pixelVert  = 49) or
        (PixelHorz = 80 and pixelVert  = 50) or
        (PixelHorz = 80 and pixelVert  = 51) or
        (PixelHorz = 85 and pixelVert  = 49) or
        (PixelHorz = 85 and pixelVert  = 50) or
        (PixelHorz = 85 and pixelVert  = 51) or
        (PixelHorz = 90 and pixelVert  = 49) or
        (PixelHorz = 90 and pixelVert  = 50) or
        (PixelHorz = 90 and pixelVert  = 51) or
        (PixelHorz = 95 and pixelVert  = 49) or
        (PixelHorz = 95 and pixelVert  = 50) or
        (PixelHorz = 95 and pixelVert  = 51) or
        (PixelHorz = 100 and pixelVert  = 49) or
        (PixelHorz = 100 and pixelVert  = 50) or
        (PixelHorz = 100 and pixelVert  = 51) or
        (PixelHorz = 105 and pixelVert  = 49) or
        (PixelHorz = 105 and pixelVert  = 50) or
        (PixelHorz = 105 and pixelVert  = 51) or
        (PixelHorz = 110 and pixelVert  = 49) or
        (PixelHorz = 110 and pixelVert  = 50) or
        (PixelHorz = 110 and pixelVert  = 51) or
        (PixelHorz = 115 and pixelVert  = 49) or
        (PixelHorz = 115 and pixelVert  = 50) or
        (PixelHorz = 115 and pixelVert  = 51) or
        (PixelHorz = 120 and pixelVert  = 49) or
        (PixelHorz = 120 and pixelVert  = 50) or
        (PixelHorz = 120 and pixelVert  = 51) or
        (PixelHorz = 125 and pixelVert  = 49) or
        (PixelHorz = 125 and pixelVert  = 50) or
        (PixelHorz = 125 and pixelVert  = 51) or
        (PixelHorz = 130 and pixelVert  = 49) or
        (PixelHorz = 130 and pixelVert  = 50) or
        (PixelHorz = 130 and pixelVert  = 51) or
        (PixelHorz = 135 and pixelVert  = 49) or
        (PixelHorz = 135 and pixelVert  = 50) or
        (PixelHorz = 135 and pixelVert  = 51) or
        (PixelHorz = 140 and pixelVert  = 49) or
        (PixelHorz = 140 and pixelVert  = 50) or
        (PixelHorz = 140 and pixelVert  = 51) or
        (PixelHorz = 145 and pixelVert  = 49) or
        (PixelHorz = 145 and pixelVert  = 50) or
        (PixelHorz = 145 and pixelVert  = 51) or
        (PixelHorz = 150 and pixelVert  = 49) or
        (PixelHorz = 150 and pixelVert  = 50) or
        (PixelHorz = 150 and pixelVert  = 51) or
        (PixelHorz = 155 and pixelVert  = 49) or
        (PixelHorz = 155 and pixelVert  = 50) or
        (PixelHorz = 155 and pixelVert  = 51) or
        (PixelHorz = 160 and pixelVert  = 49) or
        (PixelHorz = 160 and pixelVert  = 50) or
        (PixelHorz = 160 and pixelVert  = 51) or
        (PixelHorz = 165 and pixelVert  = 49) or
        (PixelHorz = 165 and pixelVert  = 50) or
        (PixelHorz = 165 and pixelVert  = 51) or
        (PixelHorz = 170 and pixelVert  = 49) or
        (PixelHorz = 170 and pixelVert  = 50) or
        (PixelHorz = 170 and pixelVert  = 51) or
        (PixelHorz = 175 and pixelVert  = 49) or
        (PixelHorz = 175 and pixelVert  = 50) or
        (PixelHorz = 175 and pixelVert  = 51) or
        (PixelHorz = 180 and pixelVert  = 49) or
        (PixelHorz = 180 and pixelVert  = 50) or
        (PixelHorz = 180 and pixelVert  = 51) or
        (PixelHorz = 185 and pixelVert  = 49) or
        (PixelHorz = 185 and pixelVert  = 50) or
        (PixelHorz = 185 and pixelVert  = 51) or
        (PixelHorz = 190 and pixelVert  = 49) or
        (PixelHorz = 190 and pixelVert  = 50) or
        (PixelHorz = 190 and pixelVert  = 51) or
        (PixelHorz = 195 and pixelVert  = 49) or
        (PixelHorz = 195 and pixelVert  = 50) or
        (PixelHorz = 195 and pixelVert  = 51))
    else '0';
    TickVert <= '1' when 
        ((pixelVert = 2 and pixelHorz  = 99) or
        (pixelVert = 2 and pixelHorz  = 100) or
        (pixelVert = 2 and pixelHorz  = 101) or
        (pixelVert = 4 and pixelHorz  = 99) or
        (pixelVert = 4 and pixelHorz  = 100) or
        (pixelVert = 4 and pixelHorz  = 101) or
        (pixelVert = 6 and pixelHorz  = 99) or
        (pixelVert = 6 and pixelHorz  = 100) or
        (pixelVert = 6 and pixelHorz  = 101) or
        (pixelVert = 8 and pixelHorz  = 99) or
        (pixelVert = 8 and pixelHorz  = 100) or
        (pixelVert = 8 and pixelHorz  = 101) or
        (pixelVert = 10 and pixelHorz  = 99) or
        (pixelVert = 10 and pixelHorz  = 100) or
        (pixelVert = 10 and pixelHorz  = 101) or
        (pixelVert = 12 and pixelHorz  = 99) or
        (pixelVert = 12 and pixelHorz  = 100) or
        (pixelVert = 12 and pixelHorz  = 101) or
        (pixelVert = 14 and pixelHorz  = 99) or
        (pixelVert = 14 and pixelHorz  = 100) or
        (pixelVert = 14 and pixelHorz  = 101) or
        (pixelVert = 16 and pixelHorz  = 99) or
        (pixelVert = 16 and pixelHorz  = 100) or
        (pixelVert = 16 and pixelHorz  = 101) or
        (pixelVert = 18 and pixelHorz  = 99) or
        (pixelVert = 18 and pixelHorz  = 100) or
        (pixelVert = 18 and pixelHorz  = 101) or
        (pixelVert = 20 and pixelHorz  = 99) or
        (pixelVert = 20 and pixelHorz  = 100) or
        (pixelVert = 20 and pixelHorz  = 101) or
        (pixelVert = 22 and pixelHorz  = 99) or
        (pixelVert = 22 and pixelHorz  = 100) or
        (pixelVert = 22 and pixelHorz  = 101) or
        (pixelVert = 24 and pixelHorz  = 99) or
        (pixelVert = 24 and pixelHorz  = 100) or
        (pixelVert = 24 and pixelHorz  = 101) or
        (pixelVert = 26 and pixelHorz  = 99) or
        (pixelVert = 26 and pixelHorz  = 100) or
        (pixelVert = 26 and pixelHorz  = 101) or
        (pixelVert = 28 and pixelHorz  = 99) or
        (pixelVert = 28 and pixelHorz  = 100) or
        (pixelVert = 28 and pixelHorz  = 101) or
        (pixelVert = 30 and pixelHorz  = 99) or
        (pixelVert = 30 and pixelHorz  = 100) or
        (pixelVert = 30 and pixelHorz  = 101) or
        (pixelVert = 32 and pixelHorz  = 99) or
        (pixelVert = 32 and pixelHorz  = 100) or
        (pixelVert = 32 and pixelHorz  = 101) or
        (pixelVert = 34 and pixelHorz  = 99) or
        (pixelVert = 34 and pixelHorz  = 100) or
        (pixelVert = 34 and pixelHorz  = 101) or
        (pixelVert = 36 and pixelHorz  = 99) or
        (pixelVert = 36 and pixelHorz  = 100) or
        (pixelVert = 36 and pixelHorz  = 101) or
        (pixelVert = 38 and pixelHorz  = 99) or
        (pixelVert = 38 and pixelHorz  = 100) or
        (pixelVert = 38 and pixelHorz  = 101) or
        (pixelVert = 40 and pixelHorz  = 99) or
        (pixelVert = 40 and pixelHorz  = 100) or
        (pixelVert = 40 and pixelHorz  = 101) or
        (pixelVert = 42 and pixelHorz  = 99) or
        (pixelVert = 42 and pixelHorz  = 100) or
        (pixelVert = 42 and pixelHorz  = 101) or
        (pixelVert = 44 and pixelHorz  = 99) or
        (pixelVert = 44 and pixelHorz  = 100) or
        (pixelVert = 44 and pixelHorz  = 101) or
        (pixelVert = 46 and pixelHorz  = 99) or
        (pixelVert = 46 and pixelHorz  = 100) or
        (pixelVert = 46 and pixelHorz  = 101) or
        (pixelVert = 48 and pixelHorz  = 99) or
        (pixelVert = 48 and pixelHorz  = 100) or
        (pixelVert = 48 and pixelHorz  = 101) or
        (pixelVert = 50 and pixelHorz  = 99) or
        (pixelVert = 50 and pixelHorz  = 100) or
        (pixelVert = 50 and pixelHorz  = 101) or
        (pixelVert = 52 and pixelHorz  = 99) or
        (pixelVert = 52 and pixelHorz  = 100) or
        (pixelVert = 52 and pixelHorz  = 101) or
        (pixelVert = 54 and pixelHorz  = 99) or
        (pixelVert = 54 and pixelHorz  = 100) or
        (pixelVert = 54 and pixelHorz  = 101) or
        (pixelVert = 56 and pixelHorz  = 99) or
        (pixelVert = 56 and pixelHorz  = 100) or
        (pixelVert = 56 and pixelHorz  = 101) or
        (pixelVert = 58 and pixelHorz  = 99) or
        (pixelVert = 58 and pixelHorz  = 100) or
        (pixelVert = 58 and pixelHorz  = 101) or
        (pixelVert = 60 and pixelHorz  = 99) or
        (pixelVert = 60 and pixelHorz  = 100) or
        (pixelVert = 60 and pixelHorz  = 101) or
        (pixelVert = 62 and pixelHorz  = 99) or
        (pixelVert = 62 and pixelHorz  = 100) or
        (pixelVert = 62 and pixelHorz  = 101) or
        (pixelVert = 64 and pixelHorz  = 99) or
        (pixelVert = 64 and pixelHorz  = 100) or
        (pixelVert = 64 and pixelHorz  = 101) or
        (pixelVert = 66 and pixelHorz  = 99) or
        (pixelVert = 66 and pixelHorz  = 100) or
        (pixelVert = 66 and pixelHorz  = 101) or
        (pixelVert = 68 and pixelHorz  = 99) or
        (pixelVert = 68 and pixelHorz  = 100) or
        (pixelVert = 68 and pixelHorz  = 101) or
        (pixelVert = 70 and pixelHorz  = 99) or
        (pixelVert = 70 and pixelHorz  = 100) or
        (pixelVert = 70 and pixelHorz  = 101) or
        (pixelVert = 72 and pixelHorz  = 99) or
        (pixelVert = 72 and pixelHorz  = 100) or
        (pixelVert = 72 and pixelHorz  = 101) or
        (pixelVert = 74 and pixelHorz  = 99) or
        (pixelVert = 74 and pixelHorz  = 100) or
        (pixelVert = 74 and pixelHorz  = 101) or
        (pixelVert = 76 and pixelHorz  = 99) or
        (pixelVert = 76 and pixelHorz  = 100) or
        (pixelVert = 76 and pixelHorz  = 101) or
        (pixelVert = 78 and pixelHorz  = 99) or
        (pixelVert = 78 and pixelHorz  = 100) or
        (pixelVert = 78 and pixelHorz  = 101) or
        (pixelVert = 80 and pixelHorz  = 99) or
        (pixelVert = 80 and pixelHorz  = 100) or
        (pixelVert = 80 and pixelHorz  = 101) or
        (pixelVert = 82 and pixelHorz  = 99) or
        (pixelVert = 82 and pixelHorz  = 100) or
        (pixelVert = 82 and pixelHorz  = 101) or
        (pixelVert = 84 and pixelHorz  = 99) or
        (pixelVert = 84 and pixelHorz  = 100) or
        (pixelVert = 84 and pixelHorz  = 101) or
        (pixelVert = 86 and pixelHorz  = 99) or
        (pixelVert = 86 and pixelHorz  = 100) or
        (pixelVert = 86 and pixelHorz  = 101) or
        (pixelVert = 88 and pixelHorz  = 99) or
        (pixelVert = 88 and pixelHorz  = 100) or
        (pixelVert = 88 and pixelHorz  = 101) or
        (pixelVert = 90 and pixelHorz  = 99) or
        (pixelVert = 90 and pixelHorz  = 100) or
        (pixelVert = 90 and pixelHorz  = 101) or
        (pixelVert = 92 and pixelHorz  = 99) or
        (pixelVert = 92 and pixelHorz  = 100) or
        (pixelVert = 92 and pixelHorz  = 101) or
        (pixelVert = 94 and pixelHorz  = 99) or
        (pixelVert = 94 and pixelHorz  = 100) or
        (pixelVert = 94 and pixelHorz  = 101) or
        (pixelVert = 96 and pixelHorz  = 99) or
        (pixelVert = 96 and pixelHorz  = 100) or
        (pixelVert = 96 and pixelHorz  = 101) or
        (pixelVert = 98 and pixelHorz  = 99) or
        (pixelVert = 98 and pixelHorz  = 100) or
        (pixelVert = 98 and pixelHorz  = 101))
    else '0';
    LineHorz <= '1' when
        (pixelVert = '10' or
        pixelVert = '20' or
        pixelVert = '30' or
        pixelVert = '40' or
        pixelVert = '50' or
        pixelVert = '60' or
        pixelVert = '70' or
        pixelVert = '80' or
        pixelVert = '90')
    else '0';
    LineVert <= '1' when
        (pixeHorz = '20' or
        pixeHorz = '40' or
        pixeHorz = '60' or
        pixeHorz = '80' or
        pixeHorz = '100' or
        pixeHorz = '120' or
        pixeHorz = '140' or
        pixeHorz = '160' or
        pixeHorz = '180')
    else '0';



end Behavioral;