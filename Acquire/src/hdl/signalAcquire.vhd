--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Fall 2022
-- File:	signalAcquire.vhd
--
-- Purp: Tie the datapath and control unit together
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.signalAcquire_Package.all;			-- include your library here with added components ac97, ac97cmd
use work.basicBuildingBlocks_package.all;		-- include the basic building block library
									
entity signalAcquire is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   reg0Magnitude: out STD_LOGIC_VECTOR(3 downto 0));	--leds	   
end signalAcquire;

architecture behavior of signalAcquire is

	signal sw: STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
	signal cw: STD_LOGIC_VECTOR(CW_WIDTH - 1 downto 0);
	signal rfData: STD_LOGIC_VECTOR(15 downto 0);
    signal prevButton, currButton: STD_LOGIC;
begin	

 	sw(BUSY_SW_BIT_INDEX) <= an7606busy;
	an7606convst <= cw(CONVST_CW_BIT_INDEX);
	an7606cs <= cw(CS_CW_BIT_INDEX);
	an7606rd <= cw(RD_CW_BIT_INDEX);
	an7606reset <= cw(RESET_AD7606_CW_BIT_INDEX);	



	Datapath:signalAcquire_Datapath
		PORT MAP ( clk => clk,
			resetn => resetn,
			an7606data => an7606data,
			rfAddr => "000",
			rfData => rfData,
			cw => cw(CW_WIDTH -1 downto 0),
			sw =>  sw(DATAPATH_SW_WIDTH - 1 downto 0));

	fsm:signalAcquire_Fsm 
		PORT MAP (  clk => clk,
				resetn => resetn,
				sw => sw(SW_WIDTH - 1 downto 0),
				cw =>  cw(CW_WIDTH - 1 downto 0)
				);


	process(clk)
	begin
		if (an7606data(15 downto 8)> FOURTH_THRESHOLD_CONSTANT) then
			reg0Magnitude <= "0000";
		elsif (an7606data(15 downto 8)> THIRD_THRESHOLD_CONSTANT) then
			reg0Magnitude <= "1000";
		elsif (an7606data(15 downto 8)> SECOND_THRESHOLD_CONSTANT) then
			reg0Magnitude <= "1100";
		elsif (an7606data(15 downto 8)> FIRST_THRESHOLD_CONSTANT) then
			reg0Magnitude <= "1110";
		else
			reg0Magnitude <= "1111";
		end if;   
	end process;

	-- Button Process
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (resetn = '0') then
				prevButton <= '0';
				currButton <= '0';
			else
				prevButton <= currButton;
				currButton <= btn(0);
				sw(START_CONV_SW_BIT_INDEX) <= currButton xor prevButton;
				
			end if;	
		end if;
	end process;
 
end behavior;
