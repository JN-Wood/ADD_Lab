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


      
    TickHorz <= '1' when (pixelHorz = 270 and pixelVert = 359) or
                (pixelHorz = 270 and pixelVert = 360) or
                (pixelHorz = 270 and pixelVert = 361) or
                (pixelHorz = 289 and pixelVert = 359) or
                (pixelHorz = 289 and pixelVert = 360) or
                (pixelHorz = 289 and pixelVert = 361) or
                (pixelHorz = 308 and pixelVert = 359) or
                (pixelHorz = 308 and pixelVert = 360) or
                (pixelHorz = 308 and pixelVert = 361) or
                (pixelHorz = 328 and pixelVert = 359) or
                (pixelHorz = 328 and pixelVert = 360) or
                (pixelHorz = 328 and pixelVert = 361) or
                (pixelHorz = 348 and pixelVert = 359) or
                (pixelHorz = 348 and pixelVert = 360) or
                (pixelHorz = 348 and pixelVert = 361) or
                (pixelHorz = 367 and pixelVert = 359) or
                (pixelHorz = 367 and pixelVert = 360) or
                (pixelHorz = 367 and pixelVert = 361) or
                (pixelHorz = 386 and pixelVert = 359) or
                (pixelHorz = 386 and pixelVert = 360) or
                (pixelHorz = 386 and pixelVert = 361) or
                (pixelHorz = 406 and pixelVert = 359) or
                (pixelHorz = 406 and pixelVert = 360) or
                (pixelHorz = 406 and pixelVert = 361) or
                (pixelHorz = 426 and pixelVert = 359) or
                (pixelHorz = 426 and pixelVert = 360) or
                (pixelHorz = 426 and pixelVert = 361) or
                (pixelHorz = 445 and pixelVert = 359) or
                (pixelHorz = 445 and pixelVert = 360) or
                (pixelHorz = 445 and pixelVert = 361) or
                (pixelHorz = 464 and pixelVert = 359) or
                (pixelHorz = 464 and pixelVert = 360) or
                (pixelHorz = 464 and pixelVert = 361) or
                (pixelHorz = 484 and pixelVert = 359) or
                (pixelHorz = 484 and pixelVert = 360) or
                (pixelHorz = 484 and pixelVert = 361) or
                (pixelHorz = 504 and pixelVert = 359) or
                (pixelHorz = 504 and pixelVert = 360) or
                (pixelHorz = 504 and pixelVert = 361) or
                (pixelHorz = 523 and pixelVert = 359) or
                (pixelHorz = 523 and pixelVert = 360) or
                (pixelHorz = 523 and pixelVert = 361) or
                (pixelHorz = 542 and pixelVert = 359) or
                (pixelHorz = 542 and pixelVert = 360) or
                (pixelHorz = 542 and pixelVert = 361) or
                (pixelHorz = 562 and pixelVert = 359) or
                (pixelHorz = 562 and pixelVert = 360) or
                (pixelHorz = 562 and pixelVert = 361) or
                (pixelHorz = 582 and pixelVert = 359) or
                (pixelHorz = 582 and pixelVert = 360) or
                (pixelHorz = 582 and pixelVert = 361) or
                (pixelHorz = 601 and pixelVert = 359) or
                (pixelHorz = 601 and pixelVert = 360) or
                (pixelHorz = 601 and pixelVert = 361) or
                (pixelHorz = 620 and pixelVert = 359) or
                (pixelHorz = 620 and pixelVert = 360) or
                (pixelHorz = 620 and pixelVert = 361) or
                (pixelHorz = 640 and pixelVert = 359) or
                (pixelHorz = 640 and pixelVert = 360) or
                (pixelHorz = 640 and pixelVert = 361) or
                (pixelHorz = 660 and pixelVert = 359) or
                (pixelHorz = 660 and pixelVert = 360) or
                (pixelHorz = 660 and pixelVert = 361) or
                (pixelHorz = 679 and pixelVert = 359) or
                (pixelHorz = 679 and pixelVert = 360) or
                (pixelHorz = 679 and pixelVert = 361) or
                (pixelHorz = 698 and pixelVert = 359) or
                (pixelHorz = 698 and pixelVert = 360) or
                (pixelHorz = 698 and pixelVert = 361) or
                (pixelHorz = 718 and pixelVert = 359) or
                (pixelHorz = 718 and pixelVert = 360) or
                (pixelHorz = 718 and pixelVert = 361) or
                (pixelHorz = 738 and pixelVert = 359) or
                (pixelHorz = 738 and pixelVert = 360) or
                (pixelHorz = 738 and pixelVert = 361) or
                (pixelHorz = 757 and pixelVert = 359) or
                (pixelHorz = 757 and pixelVert = 360) or
                (pixelHorz = 757 and pixelVert = 361) or
                (pixelHorz = 776 and pixelVert = 359) or
                (pixelHorz = 776 and pixelVert = 360) or
                (pixelHorz = 776 and pixelVert = 361) or
                (pixelHorz = 796 and pixelVert = 359) or
                (pixelHorz = 796 and pixelVert = 360) or
                (pixelHorz = 796 and pixelVert = 361) or
                (pixelHorz = 816 and pixelVert = 359) or
                (pixelHorz = 816 and pixelVert = 360) or
                (pixelHorz = 816 and pixelVert = 361) or
                (pixelHorz = 835 and pixelVert = 359) or
                (pixelHorz = 835 and pixelVert = 360) or
                (pixelHorz = 835 and pixelVert = 361) or
                (pixelHorz = 854 and pixelVert = 359) or
                (pixelHorz = 854 and pixelVert = 360) or
                (pixelHorz = 854 and pixelVert = 361) or
                (pixelHorz = 874 and pixelVert = 359) or
                (pixelHorz = 874 and pixelVert = 360) or
                (pixelHorz = 874 and pixelVert = 361) or
                (pixelHorz = 894 and pixelVert = 359) or
                (pixelHorz = 894 and pixelVert = 360) or
                (pixelHorz = 894 and pixelVert = 361) or
                (pixelHorz = 913 and pixelVert = 359) or
                (pixelHorz = 913 and pixelVert = 360) or
                (pixelHorz = 913 and pixelVert = 361) or
                (pixelHorz = 932 and pixelVert = 359) or
                (pixelHorz = 932 and pixelVert = 360) or
                (pixelHorz = 932 and pixelVert = 361) or
                (pixelHorz = 952 and pixelVert = 359) or
                (pixelHorz = 952 and pixelVert = 360) or
                (pixelHorz = 952 and pixelVert = 361) or
                (pixelHorz = 972 and pixelVert = 359) or
                (pixelHorz = 972 and pixelVert = 360) or
                (pixelHorz = 972 and pixelVert = 361) or
                (pixelHorz = 991 and pixelVert = 359) or
                (pixelHorz = 991 and pixelVert = 360) or
                (pixelHorz = 991 and pixelVert = 361) or
                (pixelHorz = 1010 and pixelVert = 359) or
                (pixelHorz = 1010 and pixelVert = 360) or
                (pixelHorz = 1010 and pixelVert = 361) else '0';

TickVert <= '1' when (pixelVert = 156 and pixelHorz = 639) or
                (pixelVert = 156 and pixelHorz = 640) or
                (pixelVert = 156 and pixelHorz = 641) or
                (pixelVert = 167 and pixelHorz = 639) or
                (pixelVert = 167 and pixelHorz = 640) or
                (pixelVert = 167 and pixelHorz = 641) or
                (pixelVert = 177 and pixelHorz = 639) or
                (pixelVert = 177 and pixelHorz = 640) or
                (pixelVert = 177 and pixelHorz = 641) or
                (pixelVert = 188 and pixelHorz = 639) or
                (pixelVert = 188 and pixelHorz = 640) or
                (pixelVert = 188 and pixelHorz = 641) or
                (pixelVert = 199 and pixelHorz = 639) or
                (pixelVert = 199 and pixelHorz = 640) or
                (pixelVert = 199 and pixelHorz = 641) or
                (pixelVert = 209 and pixelHorz = 639) or
                (pixelVert = 209 and pixelHorz = 640) or
                (pixelVert = 209 and pixelHorz = 641) or
                (pixelVert = 220 and pixelHorz = 639) or
                (pixelVert = 220 and pixelHorz = 640) or
                (pixelVert = 220 and pixelHorz = 641) or
                (pixelVert = 231 and pixelHorz = 639) or
                (pixelVert = 231 and pixelHorz = 640) or
                (pixelVert = 231 and pixelHorz = 641) or
                (pixelVert = 242 and pixelHorz = 639) or
                (pixelVert = 242 and pixelHorz = 640) or
                (pixelVert = 242 and pixelHorz = 641) or
                (pixelVert = 253 and pixelHorz = 639) or
                (pixelVert = 253 and pixelHorz = 640) or
                (pixelVert = 253 and pixelHorz = 641) or
                (pixelVert = 263 and pixelHorz = 639) or
                (pixelVert = 263 and pixelHorz = 640) or
                (pixelVert = 263 and pixelHorz = 641) or
                (pixelVert = 274 and pixelHorz = 639) or
                (pixelVert = 274 and pixelHorz = 640) or
                (pixelVert = 274 and pixelHorz = 641) or
                (pixelVert = 285 and pixelHorz = 639) or
                (pixelVert = 285 and pixelHorz = 640) or
                (pixelVert = 285 and pixelHorz = 641) or
                (pixelVert = 295 and pixelHorz = 639) or
                (pixelVert = 295 and pixelHorz = 640) or
                (pixelVert = 295 and pixelHorz = 641) or
                (pixelVert = 306 and pixelHorz = 639) or
                (pixelVert = 306 and pixelHorz = 640) or
                (pixelVert = 306 and pixelHorz = 641) or
                (pixelVert = 317 and pixelHorz = 639) or
                (pixelVert = 317 and pixelHorz = 640) or
                (pixelVert = 317 and pixelHorz = 641) or
                (pixelVert = 328 and pixelHorz = 639) or
                (pixelVert = 328 and pixelHorz = 640) or
                (pixelVert = 328 and pixelHorz = 641) or
                (pixelVert = 339 and pixelHorz = 639) or
                (pixelVert = 339 and pixelHorz = 640) or
                (pixelVert = 339 and pixelHorz = 641) or
                (pixelVert = 349 and pixelHorz = 639) or
                (pixelVert = 349 and pixelHorz = 640) or
                (pixelVert = 349 and pixelHorz = 641) or
                (pixelVert = 360 and pixelHorz = 639) or
                (pixelVert = 360 and pixelHorz = 640) or
                (pixelVert = 360 and pixelHorz = 641) or
                (pixelVert = 371 and pixelHorz = 639) or
                (pixelVert = 371 and pixelHorz = 640) or
                (pixelVert = 371 and pixelHorz = 641) or
                (pixelVert = 381 and pixelHorz = 639) or
                (pixelVert = 381 and pixelHorz = 640) or
                (pixelVert = 381 and pixelHorz = 641) or
                (pixelVert = 392 and pixelHorz = 639) or
                (pixelVert = 392 and pixelHorz = 640) or
                (pixelVert = 392 and pixelHorz = 641) or
                (pixelVert = 403 and pixelHorz = 639) or
                (pixelVert = 403 and pixelHorz = 640) or
                (pixelVert = 403 and pixelHorz = 641) or
                (pixelVert = 414 and pixelHorz = 639) or
                (pixelVert = 414 and pixelHorz = 640) or
                (pixelVert = 414 and pixelHorz = 641) or
                (pixelVert = 425 and pixelHorz = 639) or
                (pixelVert = 425 and pixelHorz = 640) or
                (pixelVert = 425 and pixelHorz = 641) or
                (pixelVert = 435 and pixelHorz = 639) or
                (pixelVert = 435 and pixelHorz = 640) or
                (pixelVert = 435 and pixelHorz = 641) or
                (pixelVert = 446 and pixelHorz = 639) or
                (pixelVert = 446 and pixelHorz = 640) or
                (pixelVert = 446 and pixelHorz = 641) or
                (pixelVert = 457 and pixelHorz = 639) or
                (pixelVert = 457 and pixelHorz = 640) or
                (pixelVert = 457 and pixelHorz = 641) or
                (pixelVert = 467 and pixelHorz = 639) or
                (pixelVert = 467 and pixelHorz = 640) or
                (pixelVert = 467 and pixelHorz = 641) or
                (pixelVert = 478 and pixelHorz = 639) or
                (pixelVert = 478 and pixelHorz = 640) or
                (pixelVert = 478 and pixelHorz = 641) or
                (pixelVert = 489 and pixelHorz = 639) or
                (pixelVert = 489 and pixelHorz = 640) or
                (pixelVert = 489 and pixelHorz = 641) or
                (pixelVert = 500 and pixelHorz = 639) or
                (pixelVert = 500 and pixelHorz = 640) or
                (pixelVert = 500 and pixelHorz = 641) or
                (pixelVert = 511 and pixelHorz = 639) or
                (pixelVert = 511 and pixelHorz = 640) or
                (pixelVert = 511 and pixelHorz = 641) or
                (pixelVert = 521 and pixelHorz = 639) or
                (pixelVert = 521 and pixelHorz = 640) or
                (pixelVert = 521 and pixelHorz = 641) or
                (pixelVert = 532 and pixelHorz = 639) or
                (pixelVert = 532 and pixelHorz = 640) or
                (pixelVert = 532 and pixelHorz = 641) or
                (pixelVert = 543 and pixelHorz = 639) or
                (pixelVert = 543 and pixelHorz = 640) or
                (pixelVert = 543 and pixelHorz = 641) or
                (pixelVert = 553 and pixelHorz = 639) or
                (pixelVert = 553 and pixelHorz = 640) or
                (pixelVert = 553 and pixelHorz = 641) or
                (pixelVert = 564 and pixelHorz = 639) or
                (pixelVert = 564 and pixelHorz = 640) or
                (pixelVert = 564 and pixelHorz = 641) else '0';

LineHorz <= '1' when (pixelHorz >= 250 and pixelHorz <= 1030) and (
    pixelVert = 188
    or pixelVert = 231
    or pixelVert = 274
    or pixelVert = 317
    or pixelVert = 360
    or pixelVert = 403
    or pixelVert = 446
    or pixelVert = 489
    or pixelVert = 532
) else '0';

LineVert <= '1' when (pixelVert >= 145 and pixelVert <= 575) and (
    pixelHorz = 328
    or pixelHorz = 406
    or pixelHorz = 484
    or pixelHorz = 562
    or pixelHorz = 640
    or pixelHorz = 718
    or pixelHorz = 796
    or pixelHorz = 874
    or pixelHorz = 952
) else '0';

    
end Behavioral;