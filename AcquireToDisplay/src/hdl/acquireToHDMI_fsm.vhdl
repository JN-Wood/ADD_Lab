--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- File:	acquireToHDMI_fsm.vhdl
-- HW:	Lab2
--	Crs:	ECE 383
--
-- Purp: The control unit for the audio O'scope
--
-- Documentation:	No help, though I used an example from my Digital
--						Design text book.
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
use work.acquireToHDMI_package.all;					-- include your library here with added components ac97, ac97cmd


entity acquireToHDMI_fsm is
    PORT (  clk : in  STD_LOGIC;
            resetn : in  STD_LOGIC;
            sw: in STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
            cw: out STD_LOGIC_VECTOR (CW_WIDTH - 1 downto 0));
end acquireToHDMI_fsm;

architecture Behavioral of acquireToHDMI_fsm is

	signal state: state_type;	-- define the state_type in your package file	
	signal SHORT_DELAY_DONE_SW: STD_LOGIC; 
    signal FORCED_MODE_SW, STORE_INTO_BRAM_SW, CH1_TRIGGER_SW: STD_LOGIC; -- do we need ch 2 trigger at all? were always triggering on channel 1 yes?
begin

    SHORT_DELAY_DONE_SW <= sw(SHORT_DELAY_DONE_SW_BIT_INDEX);
    
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (resetn = '0') then 
				state <= RESET_STATE;
			else 
				case state is				
					when RESET_STATE =>
						  state <= LONG_DELAY_STATE;
					when LONG_DELAY_STATE =>
						if (sw(LONG_DELAY_DONE_SW_BIT_INDEX) = '1') then
							state <= RESET_AD7606_STATE; --TODO: add long delay counter
						else
							state <= LONG_DELAY_STATE;
						end if;
					when RESET_AD7606_STATE =>  -- do we break off into forced and trigger mode for this part? or do we just set forced to always be 1?
						if (sw(SHORT_DELAY_DONE_SW_BIT_INDEX) = '1') then
								state <= WAIT_FORCED_STATE;
						else
							state <= RESET_AD7606_STATE;
						end if;
					when WAIT_FORCED_STATE =>
						if (sw(SINGLE_SW_BIT_INDEX) = '1') then

							state <= SET_STORE_STATE; -- b ram full resets this to clear
						else
							state <= WAIT_FORCED_STATE;
						end if;
					when SET_STORE_STATE => --controlls write enable on Bram 1 and bram 2?
							state <= BEGIN_CONVERSION_STATE;
				    when CLEAR_STORE_STATE =>
                        state <= BEGIN_CONVERSION_STATE;
					when BEGIN_CONVERSION_STATE => 
							state <= ASSERT_CONVST_STATE; 
					when ASSERT_CONVST_STATE =>
						if(sw(SHORT_DELAY_DONE_SW_BIT_INDEX) = '1') then
							state <= BUSY_0_STATE;
						else
							state <= ASSERT_CONVST_STATE;
						end if;
					when BUSY_0_STATE =>
						if(sw(BUSY_SW_BIT_INDEX) = '1') then -- this is from aquire, whats our equivilent here? 
							state <= BUSY_1_STATE;
						else
							state <= BUSY_0_STATE;
						end if;
					when BUSY_1_STATE =>
						if(sw(BUSY_SW_BIT_INDEX) = '0') then -- this is from aquire, whats our equivilent here? 
							state <= READ_CH1_LOW_STATE;
						else
							state <= BUSY_1_STATE;
						end if;
					when READ_CH1_LOW_STATE =>
						if(sw(SHORT_DELAY_DONE_SW_BIT_INDEX) = '1') then

							if (sw(STORE_SW_BIT_INDEX) = '1') then 
								state <= WRITE_CH1_BRAM_STATE; -- i dont think i understand what either of these states convey
							else 
								state <= WRITE_CH1_TRIGGER_STATE;
							end if;	
						else state <= READ_CH1_LOW_STATE;
						end if;
					-- place holder until questions answered 
					when write_CH1_BRAM_STATE =>
						state <= READ_CH1_HIGH_STATE;
					when WRITE_CH1_TRIGGER_STATE =>
						state <= READ_CH1_HIGH_STATE;
					when READ_CH1_HIGH_STATE =>
						if (sw(STORE_SW_BIT_INDEX) = '1') then
							state <= RESET_SHORT_STATE;
						else 
							state <= READ_CH1_HIGH_STATE;
						end if;
					when RESET_SHORT_STATE => 
						state <= READ_CH2_LOW_STATE;
					when READ_CH2_LOW_STATE =>
						if (sw(SHORT_DELAY_DONE_SW_BIT_INDEX) = '1') then
							if (sw(STORE_SW_BIT_INDEX) = '1') then 
								state <= WRITE_CH2_BRAM_STATE;
							else
								state <= WRITE_CH2_TRIGGER_STATE; 
							end if;
						else
							state <= READ_CH2_LOW_STATE;
						end if;
					when WRITE_CH2_BRAM_STATE =>
					   state <= READ_CH2_HIGH_STATE;
					when WRITE_CH2_TRIGGER_STATE =>
					   state <= READ_CH2_HIGH_STATE;
					when READ_CH2_HIGH_STATE =>
					   state <= WAIT_INTERVAL_STATE;
					when WAIT_INTERVAL_STATE =>
						if (sw(SAMPLE_SW_BIT_INDEX) = '1') then
							if (sw(FULL_SW_BIT_INDEX) = '1') then
								state <= BRAM_FULL_STATE;
							else
								if (sw(FORCED_MODE_SW_BIT_INDEX) = '1') then
									state <= BEGIN_CONVERSION_STATE;
								else 
									if sw(CHANNEL_1_TRIG_SW_BIT_INDEX) = '1' and sw(STORE_SW_BIT_INDEX) = '1' then
										state <= SET_STORE_STATE;
									else 
										state <= BEGIN_CONVERSION_STATE;
									end if;
								end if;
							end if;
						else 
							state <= WAIT_INTERVAL_STATE;
						end if;
					when BRAM_FULL_STATE =>
						if (sw(FORCED_MODE_SW_BIT_INDEX) = '1') then
							state <= WAIT_FORCED_STATE;
						else
							state <= CLEAR_STORE_STATE;
						end if; 
				end case;
			end if;
		end if;
	end process;

	-------------------------------------------------------------------------------
    -- Dedicated Control Word spreadsheet
    -------------------------------------------------------------------------------
	output_process: process (state)
	begin
		case state is		
            when RESET_STATE  =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"11"&"11"&"00"&"11"&"11";
			when LONG_DELAY_STATE  =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"11"&"11"&"00"&"10"&"11";
			when RESET_AD7606_STATE  =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'1'&"11"&"11"&"00"&"00"&"10";
			when WAIT_FORCED_STATE  =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"11"&"11"&"00"&"00"&"11";
			when SET_STORE_STATE  =>  cw <= '0'&'1'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"11"&"11"&"00"&"00"&"11";
			when CLEAR_STORE_STATE  =>  cw <= '1'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"00"&"11"&"00"&"00"&"11"; -- when do we do this? after the bram is full? 
			when BEGIN_CONVERSION_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'1'&'0'&'0'&'1'&'1'&'1'&'0'&"00"&"11"&"00"&"00"&"11";
			when ASSERT_CONVST_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'0'&'1'&'1'&'0'&"00"&"10"&"00"&"00"&"10";
			when BUSY_0_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"00"&"10"&"00"&"00"&"11";
			when BUSY_1_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"00"&"10"&"00"&"00"&"11";
			when READ_CH1_LOW_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"10";
			when WRITE_CH1_TRIGGER_STATE  =>  cw <= '0'&'0'&'0'&'1'&'1'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"11";
			when WRITE_CH1_BRAM_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'1'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"11";
			when READ_CH1_HIGH_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'1'&'0'&'0'&"00"&"10"&"00"&"00"&"10";
			when RESET_SHORT_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'1'&'0'&'0'&"00"&"10"&"00"&"00"&"11";
			when READ_CH2_LOW_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"10";
			when WRITE_CH2_TRIGGER_STATE  =>  cw <= '0'&'0'&'1'&'0'&'1'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"11";
			when WRITE_CH2_BRAM_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'1'&'0'&'1'&'0'&'0'&'0'&"00"&"10"&"00"&"00"&"11";
			when READ_CH2_HIGH_STATE  =>  cw <= '0'&'0'&'0'&'0'&'1'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"10"&"10"&"00"&"00"&"11";
			when WAIT_INTERVAL_STATE  =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"00"&"10"&"00"&"00"&"11";
			when BRAM_FULL_STATE      =>  cw <= '0'&'0'&'0'&'0'&'0'&'0'&'0'&'0'&'1'&'1'&'1'&'0'&"11"&"11"&"00"&"00"&"11";
		end case;
	end process;	                       

end Behavioral;



