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
                (pixelHorz = 266 and pixelVert = 359) or
                (pixelHorz = 266 and pixelVert = 360) or
                (pixelHorz = 266 and pixelVert = 361) or
                (pixelHorz = 281 and pixelVert = 359) or
                (pixelHorz = 281 and pixelVert = 360) or
                (pixelHorz = 281 and pixelVert = 361) or
                (pixelHorz = 297 and pixelVert = 359) or
                (pixelHorz = 297 and pixelVert = 360) or
                (pixelHorz = 297 and pixelVert = 361) or
                (pixelHorz = 312 and pixelVert = 359) or
                (pixelHorz = 312 and pixelVert = 360) or
                (pixelHorz = 312 and pixelVert = 361) or
                (pixelHorz = 344 and pixelVert = 359) or
                (pixelHorz = 344 and pixelVert = 360) or
                (pixelHorz = 344 and pixelVert = 361) or
                (pixelHorz = 359 and pixelVert = 359) or
                (pixelHorz = 359 and pixelVert = 360) or
                (pixelHorz = 359 and pixelVert = 361) or
                (pixelHorz = 375 and pixelVert = 359) or
                (pixelHorz = 375 and pixelVert = 360) or
                (pixelHorz = 375 and pixelVert = 361) or
                (pixelHorz = 390 and pixelVert = 359) or
                (pixelHorz = 390 and pixelVert = 360) or
                (pixelHorz = 390 and pixelVert = 361) or
                (pixelHorz = 422 and pixelVert = 359) or
                (pixelHorz = 422 and pixelVert = 360) or
                (pixelHorz = 422 and pixelVert = 361) or
                (pixelHorz = 437 and pixelVert = 359) or
                (pixelHorz = 437 and pixelVert = 360) or
                (pixelHorz = 437 and pixelVert = 361) or
                (pixelHorz = 453 and pixelVert = 359) or
                (pixelHorz = 453 and pixelVert = 360) or
                (pixelHorz = 453 and pixelVert = 361) or
                (pixelHorz = 468 and pixelVert = 359) or
                (pixelHorz = 468 and pixelVert = 360) or
                (pixelHorz = 468 and pixelVert = 361) or
                (pixelHorz = 500 and pixelVert = 359) or
                (pixelHorz = 500 and pixelVert = 360) or
                (pixelHorz = 500 and pixelVert = 361) or
                (pixelHorz = 515 and pixelVert = 359) or
                (pixelHorz = 515 and pixelVert = 360) or
                (pixelHorz = 515 and pixelVert = 361) or
                (pixelHorz = 531 and pixelVert = 359) or
                (pixelHorz = 531 and pixelVert = 360) or
                (pixelHorz = 531 and pixelVert = 361) or
                (pixelHorz = 546 and pixelVert = 359) or
                (pixelHorz = 546 and pixelVert = 360) or
                (pixelHorz = 546 and pixelVert = 361) or
                (pixelHorz = 578 and pixelVert = 359) or
                (pixelHorz = 578 and pixelVert = 360) or
                (pixelHorz = 578 and pixelVert = 361) or
                (pixelHorz = 593 and pixelVert = 359) or
                (pixelHorz = 593 and pixelVert = 360) or
                (pixelHorz = 593 and pixelVert = 361) or
                (pixelHorz = 609 and pixelVert = 359) or
                (pixelHorz = 609 and pixelVert = 360) or
                (pixelHorz = 609 and pixelVert = 361) or
                (pixelHorz = 624 and pixelVert = 359) or
                (pixelHorz = 624 and pixelVert = 360) or
                (pixelHorz = 624 and pixelVert = 361) or
                (pixelHorz = 656 and pixelVert = 359) or
                (pixelHorz = 656 and pixelVert = 360) or
                (pixelHorz = 656 and pixelVert = 361) or
                (pixelHorz = 671 and pixelVert = 359) or
                (pixelHorz = 671 and pixelVert = 360) or
                (pixelHorz = 671 and pixelVert = 361) or
                (pixelHorz = 687 and pixelVert = 359) or
                (pixelHorz = 687 and pixelVert = 360) or
                (pixelHorz = 687 and pixelVert = 361) or
                (pixelHorz = 702 and pixelVert = 359) or
                (pixelHorz = 702 and pixelVert = 360) or
                (pixelHorz = 702 and pixelVert = 361) or
                (pixelHorz = 734 and pixelVert = 359) or
                (pixelHorz = 734 and pixelVert = 360) or
                (pixelHorz = 734 and pixelVert = 361) or
                (pixelHorz = 749 and pixelVert = 359) or
                (pixelHorz = 749 and pixelVert = 360) or
                (pixelHorz = 749 and pixelVert = 361) or
                (pixelHorz = 765 and pixelVert = 359) or
                (pixelHorz = 765 and pixelVert = 360) or
                (pixelHorz = 765 and pixelVert = 361) or
                (pixelHorz = 780 and pixelVert = 359) or
                (pixelHorz = 780 and pixelVert = 360) or
                (pixelHorz = 780 and pixelVert = 361) or
                (pixelHorz = 812 and pixelVert = 359) or
                (pixelHorz = 812 and pixelVert = 360) or
                (pixelHorz = 812 and pixelVert = 361) or
                (pixelHorz = 827 and pixelVert = 359) or
                (pixelHorz = 827 and pixelVert = 360) or
                (pixelHorz = 827 and pixelVert = 361) or
                (pixelHorz = 843 and pixelVert = 359) or
                (pixelHorz = 843 and pixelVert = 360) or
                (pixelHorz = 843 and pixelVert = 361) or
                (pixelHorz = 858 and pixelVert = 359) or
                (pixelHorz = 858 and pixelVert = 360) or
                (pixelHorz = 858 and pixelVert = 361) or
                (pixelHorz = 890 and pixelVert = 359) or
                (pixelHorz = 890 and pixelVert = 360) or
                (pixelHorz = 890 and pixelVert = 361) or
                (pixelHorz = 905 and pixelVert = 359) or
                (pixelHorz = 905 and pixelVert = 360) or
                (pixelHorz = 905 and pixelVert = 361) or
                (pixelHorz = 921 and pixelVert = 359) or
                (pixelHorz = 921 and pixelVert = 360) or
                (pixelHorz = 921 and pixelVert = 361) or
                (pixelHorz = 936 and pixelVert = 359) or
                (pixelHorz = 936 and pixelVert = 360) or
                (pixelHorz = 936 and pixelVert = 361) or
                (pixelHorz = 968 and pixelVert = 359) or
                (pixelHorz = 968 and pixelVert = 360) or
                (pixelHorz = 968 and pixelVert = 361) or
                (pixelHorz = 983 and pixelVert = 359) or
                (pixelHorz = 983 and pixelVert = 360) or
                (pixelHorz = 983 and pixelVert = 361) or
                (pixelHorz = 999 and pixelVert = 359) or
                (pixelHorz = 999 and pixelVert = 360) or
                (pixelHorz = 999 and pixelVert = 361) or
                (pixelHorz = 1014 and pixelVert = 359) or
                (pixelHorz = 1014 and pixelVert = 360) or
                (pixelHorz = 1014 and pixelVert = 361)
            else '0';

TickVert <= '1' when
                (pixelVert = 154 and pixelHorz = 639) or
                (pixelVert = 154 and pixelHorz = 640) or
                (pixelVert = 154 and pixelHorz = 641) or
                (pixelVert = 162 and pixelHorz = 639) or
                (pixelVert = 162 and pixelHorz = 640) or
                (pixelVert = 162 and pixelHorz = 641) or
                (pixelVert = 171 and pixelHorz = 639) or
                (pixelVert = 171 and pixelHorz = 640) or
                (pixelVert = 171 and pixelHorz = 641) or
                (pixelVert = 179 and pixelHorz = 639) or
                (pixelVert = 179 and pixelHorz = 640) or
                (pixelVert = 179 and pixelHorz = 641) or
                (pixelVert = 197 and pixelHorz = 639) or
                (pixelVert = 197 and pixelHorz = 640) or
                (pixelVert = 197 and pixelHorz = 641) or
                (pixelVert = 205 and pixelHorz = 639) or
                (pixelVert = 205 and pixelHorz = 640) or
                (pixelVert = 205 and pixelHorz = 641) or
                (pixelVert = 214 and pixelHorz = 639) or
                (pixelVert = 214 and pixelHorz = 640) or
                (pixelVert = 214 and pixelHorz = 641) or
                (pixelVert = 222 and pixelHorz = 639) or
                (pixelVert = 222 and pixelHorz = 640) or
                (pixelVert = 222 and pixelHorz = 641) or
                (pixelVert = 240 and pixelHorz = 639) or
                (pixelVert = 240 and pixelHorz = 640) or
                (pixelVert = 240 and pixelHorz = 641) or
                (pixelVert = 248 and pixelHorz = 639) or
                (pixelVert = 248 and pixelHorz = 640) or
                (pixelVert = 248 and pixelHorz = 641) or
                (pixelVert = 257 and pixelHorz = 639) or
                (pixelVert = 257 and pixelHorz = 640) or
                (pixelVert = 257 and pixelHorz = 641) or
                (pixelVert = 265 and pixelHorz = 639) or
                (pixelVert = 265 and pixelHorz = 640) or
                (pixelVert = 265 and pixelHorz = 641) or
                (pixelVert = 283 and pixelHorz = 639) or
                (pixelVert = 283 and pixelHorz = 640) or
                (pixelVert = 283 and pixelHorz = 641) or
                (pixelVert = 291 and pixelHorz = 639) or
                (pixelVert = 291 and pixelHorz = 640) or
                (pixelVert = 291 and pixelHorz = 641) or
                (pixelVert = 300 and pixelHorz = 639) or
                (pixelVert = 300 and pixelHorz = 640) or
                (pixelVert = 300 and pixelHorz = 641) or
                (pixelVert = 308 and pixelHorz = 639) or
                (pixelVert = 308 and pixelHorz = 640) or
                (pixelVert = 308 and pixelHorz = 641) or
                (pixelVert = 326 and pixelHorz = 639) or
                (pixelVert = 326 and pixelHorz = 640) or
                (pixelVert = 326 and pixelHorz = 641) or
                (pixelVert = 334 and pixelHorz = 639) or
                (pixelVert = 334 and pixelHorz = 640) or
                (pixelVert = 334 and pixelHorz = 641) or
                (pixelVert = 343 and pixelHorz = 639) or
                (pixelVert = 343 and pixelHorz = 640) or
                (pixelVert = 343 and pixelHorz = 641) or
                (pixelVert = 351 and pixelHorz = 639) or
                (pixelVert = 351 and pixelHorz = 640) or
                (pixelVert = 351 and pixelHorz = 641) or
                (pixelVert = 369 and pixelHorz = 639) or
                (pixelVert = 369 and pixelHorz = 640) or
                (pixelVert = 369 and pixelHorz = 641) or
                (pixelVert = 377 and pixelHorz = 639) or
                (pixelVert = 377 and pixelHorz = 640) or
                (pixelVert = 377 and pixelHorz = 641) or
                (pixelVert = 386 and pixelHorz = 639) or
                (pixelVert = 386 and pixelHorz = 640) or
                (pixelVert = 386 and pixelHorz = 641) or
                (pixelVert = 394 and pixelHorz = 639) or
                (pixelVert = 394 and pixelHorz = 640) or
                (pixelVert = 394 and pixelHorz = 641) or
                (pixelVert = 412 and pixelHorz = 639) or
                (pixelVert = 412 and pixelHorz = 640) or
                (pixelVert = 412 and pixelHorz = 641) or
                (pixelVert = 420 and pixelHorz = 639) or
                (pixelVert = 420 and pixelHorz = 640) or
                (pixelVert = 420 and pixelHorz = 641) or
                (pixelVert = 429 and pixelHorz = 639) or
                (pixelVert = 429 and pixelHorz = 640) or
                (pixelVert = 429 and pixelHorz = 641) or
                (pixelVert = 437 and pixelHorz = 639) or
                (pixelVert = 437 and pixelHorz = 640) or
                (pixelVert = 437 and pixelHorz = 641) or
                (pixelVert = 455 and pixelHorz = 639) or
                (pixelVert = 455 and pixelHorz = 640) or
                (pixelVert = 455 and pixelHorz = 641) or
                (pixelVert = 463 and pixelHorz = 639) or
                (pixelVert = 463 and pixelHorz = 640) or
                (pixelVert = 463 and pixelHorz = 641) or
                (pixelVert = 472 and pixelHorz = 639) or
                (pixelVert = 472 and pixelHorz = 640) or
                (pixelVert = 472 and pixelHorz = 641) or
                (pixelVert = 480 and pixelHorz = 639) or
                (pixelVert = 480 and pixelHorz = 640) or
                (pixelVert = 480 and pixelHorz = 641) or
                (pixelVert = 498 and pixelHorz = 639) or
                (pixelVert = 498 and pixelHorz = 640) or
                (pixelVert = 498 and pixelHorz = 641) or
                (pixelVert = 506 and pixelHorz = 639) or
                (pixelVert = 506 and pixelHorz = 640) or
                (pixelVert = 506 and pixelHorz = 641) or
                (pixelVert = 515 and pixelHorz = 639) or
                (pixelVert = 515 and pixelHorz = 640) or
                (pixelVert = 515 and pixelHorz = 641) or
                (pixelVert = 523 and pixelHorz = 639) or
                (pixelVert = 523 and pixelHorz = 640) or
                (pixelVert = 523 and pixelHorz = 641) or
                (pixelVert = 541 and pixelHorz = 639) or
                (pixelVert = 541 and pixelHorz = 640) or
                (pixelVert = 541 and pixelHorz = 641) or
                (pixelVert = 549 and pixelHorz = 639) or
                (pixelVert = 549 and pixelHorz = 640) or
                (pixelVert = 549 and pixelHorz = 641) or
                (pixelVert = 558 and pixelHorz = 639) or
                (pixelVert = 558 and pixelHorz = 640) or
                (pixelVert = 558 and pixelHorz = 641) or
                (pixelVert = 566 and pixelHorz = 639) or
                (pixelVert = 566 and pixelHorz = 640) or
                (pixelVert = 566 and pixelHorz = 641)
            else '0';

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