--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- Modified:	Sept 2022
-- File:	lab2_datapath.vhdl
-- HW:	Lab 2
--	Crs:	ECE 383 and EENG 498
--
-- Purp: The datapath for the audio O'scope
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
use work.basicBuildingBlocks_package.all;				-- include the basic building block library

entity signalAcquire_Datapath is
		   cw : in STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
		   sw : out STD_
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   rfAddr: in STD_LOGIC_VECTOR(2 downto 0);
		   rfData: out STD_LOGIC_VECTOR(15 downto 0) );
end signalAcquire_Datapath;

architecture behavior of signalAcquire_Datapath is

	signal longDelayCounterOut: STD_LOGIC_VECTOR(LONG_DELAY_50Mhz_CONST_WIDTH - 1 downto 0);
	signal shortDelayCounterOut: STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0);	
	signal regCountOut: STD_LOGIC_VECTOR(3 downto 0);
begin

	--Long delay counter instantiation
	longDelayCounter: genericCounter
		generic Map(N => LONG_DELAY_50Mhz_CONST_WIDTH)
		port Map(	clk => clk,
					resetn => resetn,
					c => cw(LONG_DELAY_CW_BIT_INDEX),
					q => longDelayCounterOut,
					d => x'000000'
	);

	--Short delay counter instantiation
	shortDelayCounter: genericCounter
		generic Map(N => SHORT_DELAY_50Mhz_CONST_WIDTH)
		port Map(	clk => clk,
					resetn => resetn,
					c => cw(SHORT_DELAY_CW_BIT_INDEX),
					q => shortDelayCounterOut,
					d => x'000000'
	);

	-- Long delay comparator instantiation
	longDelayComparator: genericComparator
		generic Map(N => LONG_DELAY_50Mhz_CONST_WIDTH)
		port Map(	x => LONG_DELAY_50Mhz_COUNTS,
					y => longDelayCounterOut,
					g => open,
					l => open,
					e => sw(LONG_DELAY_DONE_SW_BIT_INDEX)
	);

	-- Short delay comparator instantiation
	shortDelayComparator: genericComparator
		generic Map(N => SHORT_DELAY_50Mhz_CONST_WIDTH)
		port Map(	x => SHORT_DELAY_50Mhz_COUNTS,
					y => shortDelayCounterOut,
					g => open,
					l => open,
					e => sw(SHORT_DELAY_DONE_SW_BIT_INDEX)
	);
	
	-- Reg file counter instantiation
	regCount: genericCounter
		generic Map(N => 4)
		port Map(	clk => clk,
					resetn => resetn,
					c => cw(REGCOUNT_CW_BIT_INDEX),
					q => x'0000',
					d => regCountOut`
		);

	-- reg file comparator instantiation
	regCompare: genericComparator
		generic Map(N => 4)
		port Map(	x => '0111',
					y => regCountOut,
					g => open,
					l => open,
					e => sw(ALL_CHANNELS_HAVE_BEEN_READ_SW_BIT_INDEX)
				);

	-- reg file instantiation
	regFile: regFile8x16
		generic Map(N => 16)
		port Map(  clk => clk, 
				resetn => resetn,
                write => cw(REGFILE_WRITE_CW_BIT_INDEX),
                wrAddr => regCountOut(2 downto 0),	-- Use the 3 LSBs of the 4-bit counter to write to the register file
                rdAddr => rfAddr,
                D => an7606data,
                Q => rfData 
				);


	<complete>

end behavior;
