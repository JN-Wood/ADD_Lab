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
                elsif ch1 = '1' then -- changed ch1Wave to ch1
                    red <= CH1_R;
                    green <= CH1_G;
                    blue <= CH1_B;
                elsif ch2 = '1' then -- changed ch1Wave to ch1
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
    borderBottom <= '1' when    ((pixelVert > B_EDGE - BORDER_LINE_WIDTH) and (pixelVert < B_EDGE + BORDER_LINE_WIDTH ) and
                            (pixelHorz > L_EDGE- BORDER_LINE_WIDTH) and (pixelHorz < R_EDGE+BORDER_LINE_WIDTH)) else
                            '0';
    borderLeft <=   '1' when    ((pixelHorz > L_EDGE - BORDER_LINE_WIDTH ) and (pixelHorz < L_EDGE + BORDER_LINE_WIDTH ) and
                            ( pixelVert > T_EDGE-BORDER_LINE_WIDTH) and (pixelVert < B_EDGE+BORDER_LINE_WIDTH)) else
                            '0';       
    borderRight <=  '1' when    ((pixelHorz > R_EDGE - BORDER_LINE_WIDTH) and (pixelHorz < R_EDGE + BORDER_LINE_WIDTH) and 
                            ( pixelVert > T_EDGE-BORDER_LINE_WIDTH) and (pixelVert < B_EDGE+BORDER_LINE_WIDTH)) else
                            '0';

    triggerVoltMarker <= '1' when (pixelHorz >= L_EDGE + BORDER_LINE_WIDTH) and 
                              (pixelHorz <= L_EDGE + BORDER_LINE_WIDTH + TRIGGER_MARKER_HEIGHT) and 
                              (pixelVert >= (triggerVolt + T_EDGE + BORDER_LINE_WIDTH) - (TRIGGER_MARKER_WIDTH - (pixelHorz - (L_EDGE + BORDER_LINE_WIDTH)))) and 
                              (pixelVert <= (triggerVolt + T_EDGE + BORDER_LINE_WIDTH) + (TRIGGER_MARKER_WIDTH - (pixelHorz - (L_EDGE + BORDER_LINE_WIDTH)))) else
                        '0';

    triggerTimeMarker <= '1' when (pixelVert >= T_EDGE + BORDER_LINE_WIDTH) and 
                              (pixelVert < T_EDGE + BORDER_LINE_WIDTH + TRIGGER_MARKER_HEIGHT) and 
                              (pixelHorz >= (triggerTime + L_EDGE + BORDER_LINE_WIDTH) - (TRIGGER_MARKER_WIDTH - (pixelVert - (T_EDGE + BORDER_LINE_WIDTH)))) and 
                              (pixelHorz <= (triggerTime + L_EDGE + BORDER_LINE_WIDTH) + (TRIGGER_MARKER_WIDTH - (pixelVert - (T_EDGE + BORDER_LINE_WIDTH)))) else
                        '0';


      
    TickHorz <= '1' when 
        ((PixelHorz = 269 and pixelVert  = 214) or
        (PixelHorz = 269 and pixelVert  = 215) or
        (PixelHorz = 269 and pixelVert  = 216) or
        (PixelHorz = 288 and pixelVert  = 214) or
        (PixelHorz = 288 and pixelVert  = 215) or
        (PixelHorz = 288 and pixelVert  = 216) or
        (PixelHorz = 307 and pixelVert  = 214) or
        (PixelHorz = 307 and pixelVert  = 215) or
        (PixelHorz = 307 and pixelVert  = 216) or
        (PixelHorz = 326 and pixelVert  = 214) or
        (PixelHorz = 326 and pixelVert  = 215) or
        (PixelHorz = 326 and pixelVert  = 216) or
        (PixelHorz = 345 and pixelVert  = 214) or
        (PixelHorz = 345 and pixelVert  = 215) or
        (PixelHorz = 345 and pixelVert  = 216) or
        (PixelHorz = 364 and pixelVert  = 214) or
        (PixelHorz = 364 and pixelVert  = 215) or
        (PixelHorz = 364 and pixelVert  = 216) or
        (PixelHorz = 383 and pixelVert  = 214) or
        (PixelHorz = 383 and pixelVert  = 215) or
        (PixelHorz = 383 and pixelVert  = 216) or
        (PixelHorz = 402 and pixelVert  = 214) or
        (PixelHorz = 402 and pixelVert  = 215) or
        (PixelHorz = 402 and pixelVert  = 216) or
        (PixelHorz = 421 and pixelVert  = 214) or
        (PixelHorz = 421 and pixelVert  = 215) or
        (PixelHorz = 421 and pixelVert  = 216) or
        (PixelHorz = 440 and pixelVert  = 214) or
        (PixelHorz = 440 and pixelVert  = 215) or
        (PixelHorz = 440 and pixelVert  = 216) or
        (PixelHorz = 459 and pixelVert  = 214) or
        (PixelHorz = 459 and pixelVert  = 215) or
        (PixelHorz = 459 and pixelVert  = 216) or
        (PixelHorz = 478 and pixelVert  = 214) or
        (PixelHorz = 478 and pixelVert  = 215) or
        (PixelHorz = 478 and pixelVert  = 216) or
        (PixelHorz = 497 and pixelVert  = 214) or
        (PixelHorz = 497 and pixelVert  = 215) or
        (PixelHorz = 497 and pixelVert  = 216) or
        (PixelHorz = 516 and pixelVert  = 214) or
        (PixelHorz = 516 and pixelVert  = 215) or
        (PixelHorz = 516 and pixelVert  = 216) or
        (PixelHorz = 535 and pixelVert  = 214) or
        (PixelHorz = 535 and pixelVert  = 215) or
        (PixelHorz = 535 and pixelVert  = 216) or
        (PixelHorz = 554 and pixelVert  = 214) or
        (PixelHorz = 554 and pixelVert  = 215) or
        (PixelHorz = 554 and pixelVert  = 216) or
        (PixelHorz = 573 and pixelVert  = 214) or
        (PixelHorz = 573 and pixelVert  = 215) or
        (PixelHorz = 573 and pixelVert  = 216) or
        (PixelHorz = 592 and pixelVert  = 214) or
        (PixelHorz = 592 and pixelVert  = 215) or
        (PixelHorz = 592 and pixelVert  = 216) or
        (PixelHorz = 611 and pixelVert  = 214) or
        (PixelHorz = 611 and pixelVert  = 215) or
        (PixelHorz = 611 and pixelVert  = 216) or
        (PixelHorz = 630 and pixelVert  = 214) or
        (PixelHorz = 630 and pixelVert  = 215) or
        (PixelHorz = 630 and pixelVert  = 216) or
        (PixelHorz = 649 and pixelVert  = 214) or
        (PixelHorz = 649 and pixelVert  = 215) or
        (PixelHorz = 649 and pixelVert  = 216) or
        (PixelHorz = 668 and pixelVert  = 214) or
        (PixelHorz = 668 and pixelVert  = 215) or
        (PixelHorz = 668 and pixelVert  = 216) or
        (PixelHorz = 687 and pixelVert  = 214) or
        (PixelHorz = 687 and pixelVert  = 215) or
        (PixelHorz = 687 and pixelVert  = 216) or
        (PixelHorz = 706 and pixelVert  = 214) or
        (PixelHorz = 706 and pixelVert  = 215) or
        (PixelHorz = 706 and pixelVert  = 216) or
        (PixelHorz = 725 and pixelVert  = 214) or
        (PixelHorz = 725 and pixelVert  = 215) or
        (PixelHorz = 725 and pixelVert  = 216) or
        (PixelHorz = 744 and pixelVert  = 214) or
        (PixelHorz = 744 and pixelVert  = 215) or
        (PixelHorz = 744 and pixelVert  = 216) or
        (PixelHorz = 763 and pixelVert  = 214) or
        (PixelHorz = 763 and pixelVert  = 215) or
        (PixelHorz = 763 and pixelVert  = 216) or
        (PixelHorz = 782 and pixelVert  = 214) or
        (PixelHorz = 782 and pixelVert  = 215) or
        (PixelHorz = 782 and pixelVert  = 216) or
        (PixelHorz = 801 and pixelVert  = 214) or
        (PixelHorz = 801 and pixelVert  = 215) or
        (PixelHorz = 801 and pixelVert  = 216) or
        (PixelHorz = 820 and pixelVert  = 214) or
        (PixelHorz = 820 and pixelVert  = 215) or
        (PixelHorz = 820 and pixelVert  = 216) or
        (PixelHorz = 839 and pixelVert  = 214) or
        (PixelHorz = 839 and pixelVert  = 215) or
        (PixelHorz = 839 and pixelVert  = 216) or
        (PixelHorz = 858 and pixelVert  = 214) or
        (PixelHorz = 858 and pixelVert  = 215) or
        (PixelHorz = 858 and pixelVert  = 216) or
        (PixelHorz = 877 and pixelVert  = 214) or
        (PixelHorz = 877 and pixelVert  = 215) or
        (PixelHorz = 877 and pixelVert  = 216) or
        (PixelHorz = 896 and pixelVert  = 214) or
        (PixelHorz = 896 and pixelVert  = 215) or
        (PixelHorz = 896 and pixelVert  = 216) or
        (PixelHorz = 915 and pixelVert  = 214) or
        (PixelHorz = 915 and pixelVert  = 215) or
        (PixelHorz = 915 and pixelVert  = 216) or
        (PixelHorz = 934 and pixelVert  = 214) or
        (PixelHorz = 934 and pixelVert  = 215) or
        (PixelHorz = 934 and pixelVert  = 216) or
        (PixelHorz = 953 and pixelVert  = 214) or
        (PixelHorz = 953 and pixelVert  = 215) or
        (PixelHorz = 953 and pixelVert  = 216) or
        (PixelHorz = 972 and pixelVert  = 214) or
        (PixelHorz = 972 and pixelVert  = 215) or
        (PixelHorz = 972 and pixelVert  = 216) or
        (PixelHorz = 991 and pixelVert  = 214) or
        (PixelHorz = 991 and pixelVert  = 215) or
        (PixelHorz = 991 and pixelVert  = 216) or
        (PixelHorz = 1010 and pixelVert  = 214) or
        (PixelHorz = 1010 and pixelVert  = 215) or
        (PixelHorz = 1010 and pixelVert  = 216))
    else '0';
    TickVert <= '1' when 
        ((pixelVert = 155 and pixelHorz  = 389) or
        (pixelVert = 155 and pixelHorz  = 390) or
        (pixelVert = 155 and pixelHorz  = 391) or
        (pixelVert = 165 and pixelHorz  = 389) or
        (pixelVert = 165 and pixelHorz  = 390) or
        (pixelVert = 165 and pixelHorz  = 391) or
        (pixelVert = 175 and pixelHorz  = 389) or
        (pixelVert = 175 and pixelHorz  = 390) or
        (pixelVert = 175 and pixelHorz  = 391) or
        (pixelVert = 185 and pixelHorz  = 389) or
        (pixelVert = 185 and pixelHorz  = 390) or
        (pixelVert = 185 and pixelHorz  = 391) or
        (pixelVert = 195 and pixelHorz  = 389) or
        (pixelVert = 195 and pixelHorz  = 390) or
        (pixelVert = 195 and pixelHorz  = 391) or
        (pixelVert = 205 and pixelHorz  = 389) or
        (pixelVert = 205 and pixelHorz  = 390) or
        (pixelVert = 205 and pixelHorz  = 391) or
        (pixelVert = 215 and pixelHorz  = 389) or
        (pixelVert = 215 and pixelHorz  = 390) or
        (pixelVert = 215 and pixelHorz  = 391) or
        (pixelVert = 225 and pixelHorz  = 389) or
        (pixelVert = 225 and pixelHorz  = 390) or
        (pixelVert = 225 and pixelHorz  = 391) or
        (pixelVert = 235 and pixelHorz  = 389) or
        (pixelVert = 235 and pixelHorz  = 390) or
        (pixelVert = 235 and pixelHorz  = 391) or
        (pixelVert = 245 and pixelHorz  = 389) or
        (pixelVert = 245 and pixelHorz  = 390) or
        (pixelVert = 245 and pixelHorz  = 391) or
        (pixelVert = 255 and pixelHorz  = 389) or
        (pixelVert = 255 and pixelHorz  = 390) or
        (pixelVert = 255 and pixelHorz  = 391) or
        (pixelVert = 265 and pixelHorz  = 389) or
        (pixelVert = 265 and pixelHorz  = 390) or
        (pixelVert = 265 and pixelHorz  = 391) or
        (pixelVert = 275 and pixelHorz  = 389) or
        (pixelVert = 275 and pixelHorz  = 390) or
        (pixelVert = 275 and pixelHorz  = 391) or
        (pixelVert = 285 and pixelHorz  = 389) or
        (pixelVert = 285 and pixelHorz  = 390) or
        (pixelVert = 285 and pixelHorz  = 391) or
        (pixelVert = 295 and pixelHorz  = 389) or
        (pixelVert = 295 and pixelHorz  = 390) or
        (pixelVert = 295 and pixelHorz  = 391) or
        (pixelVert = 305 and pixelHorz  = 389) or
        (pixelVert = 305 and pixelHorz  = 390) or
        (pixelVert = 305 and pixelHorz  = 391) or
        (pixelVert = 315 and pixelHorz  = 389) or
        (pixelVert = 315 and pixelHorz  = 390) or
        (pixelVert = 315 and pixelHorz  = 391) or
        (pixelVert = 325 and pixelHorz  = 389) or
        (pixelVert = 325 and pixelHorz  = 390) or
        (pixelVert = 325 and pixelHorz  = 391) or
        (pixelVert = 335 and pixelHorz  = 389) or
        (pixelVert = 335 and pixelHorz  = 390) or
        (pixelVert = 335 and pixelHorz  = 391) or
        (pixelVert = 345 and pixelHorz  = 389) or
        (pixelVert = 345 and pixelHorz  = 390) or
        (pixelVert = 345 and pixelHorz  = 391) or
        (pixelVert = 355 and pixelHorz  = 389) or
        (pixelVert = 355 and pixelHorz  = 390) or
        (pixelVert = 355 and pixelHorz  = 391) or
        (pixelVert = 365 and pixelHorz  = 389) or
        (pixelVert = 365 and pixelHorz  = 390) or
        (pixelVert = 365 and pixelHorz  = 391) or
        (pixelVert = 375 and pixelHorz  = 389) or
        (pixelVert = 375 and pixelHorz  = 390) or
        (pixelVert = 375 and pixelHorz  = 391) or
        (pixelVert = 385 and pixelHorz  = 389) or
        (pixelVert = 385 and pixelHorz  = 390) or
        (pixelVert = 385 and pixelHorz  = 391) or
        (pixelVert = 395 and pixelHorz  = 389) or
        (pixelVert = 395 and pixelHorz  = 390) or
        (pixelVert = 395 and pixelHorz  = 391) or
        (pixelVert = 405 and pixelHorz  = 389) or
        (pixelVert = 405 and pixelHorz  = 390) or
        (pixelVert = 405 and pixelHorz  = 391) or
        (pixelVert = 415 and pixelHorz  = 389) or
        (pixelVert = 415 and pixelHorz  = 390) or
        (pixelVert = 415 and pixelHorz  = 391) or
        (pixelVert = 425 and pixelHorz  = 389) or
        (pixelVert = 425 and pixelHorz  = 390) or
        (pixelVert = 425 and pixelHorz  = 391) or
        (pixelVert = 435 and pixelHorz  = 389) or
        (pixelVert = 435 and pixelHorz  = 390) or
        (pixelVert = 435 and pixelHorz  = 391) or
        (pixelVert = 445 and pixelHorz  = 389) or
        (pixelVert = 445 and pixelHorz  = 390) or
        (pixelVert = 445 and pixelHorz  = 391) or
        (pixelVert = 455 and pixelHorz  = 389) or
        (pixelVert = 455 and pixelHorz  = 390) or
        (pixelVert = 455 and pixelHorz  = 391) or
        (pixelVert = 465 and pixelHorz  = 389) or
        (pixelVert = 465 and pixelHorz  = 390) or
        (pixelVert = 465 and pixelHorz  = 391) or
        (pixelVert = 475 and pixelHorz  = 389) or
        (pixelVert = 475 and pixelHorz  = 390) or
        (pixelVert = 475 and pixelHorz  = 391) or
        (pixelVert = 485 and pixelHorz  = 389) or
        (pixelVert = 485 and pixelHorz  = 390) or
        (pixelVert = 485 and pixelHorz  = 391) or
        (pixelVert = 495 and pixelHorz  = 389) or
        (pixelVert = 495 and pixelHorz  = 390) or
        (pixelVert = 495 and pixelHorz  = 391) or
        (pixelVert = 505 and pixelHorz  = 389) or
        (pixelVert = 505 and pixelHorz  = 390) or
        (pixelVert = 505 and pixelHorz  = 391) or
        (pixelVert = 515 and pixelHorz  = 389) or
        (pixelVert = 515 and pixelHorz  = 390) or
        (pixelVert = 515 and pixelHorz  = 391) or
        (pixelVert = 525 and pixelHorz  = 389) or
        (pixelVert = 525 and pixelHorz  = 390) or
        (pixelVert = 525 and pixelHorz  = 391) or
        (pixelVert = 535 and pixelHorz  = 389) or
        (pixelVert = 535 and pixelHorz  = 390) or
        (pixelVert = 535 and pixelHorz  = 391) or
        (pixelVert = 545 and pixelHorz  = 389) or
        (pixelVert = 545 and pixelHorz  = 390) or
        (pixelVert = 545 and pixelHorz  = 391) or
        (pixelVert = 555 and pixelHorz  = 389) or
        (pixelVert = 555 and pixelHorz  = 390) or
        (pixelVert = 555 and pixelHorz  = 391))
    else '0';
    LineHorz <= '1' when
        (pixelVert = 188 or
        pixelVert = 231 or
        pixelVert = 274 or
        pixelVert = 317 or
        pixelVert = 360 or
        pixelVert = 403 or
        pixelVert = 446 or
        pixelVert = 489 or
        pixelVert = 532)
    else '0';
    
    LineVert <= '1' when
        (pixelHorz = 328 or
        pixelHorz = 406 or
        pixelHorz = 484 or
        pixelHorz = 562 or
        pixelHorz = 640 or
        pixelHorz = 718 or
        pixelHorz = 796 or
        pixelHorz = 874 or
        pixelHorz = 952)
    else '0';


end Behavioral;