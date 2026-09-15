----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity videoSignalGenerator is
    PORT(	
         clk: in  STD_LOGIC;
         resetn : in  STD_LOGIC;
         hs: out STD_LOGIC;
         vs: out STD_LOGIC;
         de: out STD_LOGIC;
         pixelHorz: out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
         pixelVert: out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0));
end videoSignalGenerator;

architecture behavior of videoSignalGenerator is


    signal h_cnt, v_cnt : STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0);
    signal h_activeArea, v_activeArea: STD_LOGIC;


begin

    -- Register the de (active video area) signal
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then                
                de <= '0';
            else
                de <= h_activeArea and v_activeArea;
            end if;
        end if;
    end process;


    -- 1: Increment the horziontal count across the video screen
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                h_cnt <= (others => '0');
            elsif(h_cnt = (H_TOTAL - 1)) then
                h_cnt <= (others => '0');
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    -- 2: Assert the horziontal synch signal



    -- 3: Generate the pixelHorz signal that is used by
    -- the scopeFace and other components to know which pixel on 
    -- the screen is being drawn.


    -- 4. assert the h_activeArea signal.  This boolean is true when we are drawing pixels



    -- 1: Increment the vertical count across the video screen
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                v_cnt <= (others => '0');
            elsif(h_cnt = H_FP - 1) then
                if(v_cnt = (V_TOTAL - 1)) then
                    v_cnt <= (others => '0');
                else
                    v_cnt <= v_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- 2: Assert the vertical synch signal
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                vs <= '1';
            elsif((v_cnt = V_FP - 1) and (h_cnt = H_FP - 1)) then
                vs <= '0';
            elsif((v_cnt = V_FP + V_SYNC - 1) and (h_cnt = H_FP - 1)) then
                vs <= '1';            
            end if;
        end if;
    end process;


    -- 3: Generate the pixelHorz signal that is used by
    -- the scopeFace and other components to know which pixel on 
    -- the screen is being drawn.
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                pixelVert <= (others => '0');
            elsif(v_cnt >= V_FP + V_SYNC + V_BP - 1) then
                pixelVert <= v_cnt - (V_FP + V_SYNC + V_BP - 1);
            end if;
        end if;
    end process;

    -- 4. assert the v_activeArea signal.  This boolean is true when we are drawing pixels
    process(clk)
    begin
        if rising_edge (clk) then
            if resetn = '0' then
                v_activeArea <= '0';
            elsif((v_cnt = V_FP + V_SYNC + V_BP - 1) and (h_cnt = H_FP - 1))then
                v_activeArea <= '1';
            elsif((v_cnt = V_TOTAL - 1) and (h_cnt = H_FP - 1)) then
                v_activeArea <= '0';
            else
                v_activeArea <= v_activeArea;
            end if;
        end if;
    end process;

end behavior;
