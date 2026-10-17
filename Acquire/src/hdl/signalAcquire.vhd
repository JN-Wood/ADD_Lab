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
use worlk.signalAcquire_Package.all;			-- include your library here with added components ac97, ac97cmd
use work.basicBuildingBlocks_package.all;		-- include the basic building block library
									
entity signalAcquire is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   reg0Magnitude: out STD_LOGIC_VECTOR(3 downto 0));		   
end signalAcquire;

architecture behavior of signalAcquire is

	signal sw: STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
	signal cw: STD_LOGIC_VECTOR(CW_WIDTH - 1 downto 0);
	signal rfData: STD_LOGIC_VECTOR(15 downto 0);
    	
begin	


	

	-- Button Process
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (resetn = '0') then	

	<complete>


 
end behavior;
