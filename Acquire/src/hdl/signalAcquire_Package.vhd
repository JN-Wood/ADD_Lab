--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Fall 2023
-- File:	signalAcquire_Package.vhd
--
-- Purp: Defines signalAcquire specific components and defines constants
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


package signalAcquire_Package is


-- Clock period definitions
constant clk_period : time := 20 ns;			-- 50Mhz crystal input (XTL_IN).
   
   
    CONSTANT CONVST_CW_BIT_INDEX : NATURAL := 10;
    CONSTANT RD_CW_BIT_INDEX : NATURAL := 9;
    CONSTANT CS_CW_BIT_INDEX : NATURAL := 8;
    CONSTANT RESET_AD7606_CW_BIT_INDEX : NATURAL := 7;
    CONSTANT LONG_COUNT_CW_BIT_1_INDEX : NATURAL := 6;
    CONSTANT LONG_COUNT_CW_BIT_0_INDEX : NATURAL := 5;
    CONSTANT SHORT_COUNT_CW_BIT_1_INDEX : NATURAL := 4;
    CONSTANT SHORT_COUNT_CW_BIT_0_INDEX : NATURAL := 3;
    CONSTANT REG_COUNT_CW_BIT_1_INDEX : NATURAL := 2;
    CONSTANT REG_COUNT_CW_BIT_0_INDEX : NATURAL := 1;
    CONSTANT REF_FILE_WRITE_CW_BIT_INDEX : NATURAL := 0;
    

    CONSTANT DATAPATH_SW_WIDTH : NATURAL := 3;  
    CONSTANT ALL_CHANNELS_HAVE_BEEN_READ_SW_BIT_INDEX : NATURAL := 0;
    CONSTANT SHORT_DELAY_DONE_SW_BIT_INDEX : NATURAL := 1;
    CONSTANT LONG_DELAY_DONE_SW_BIT_INDEX : NATURAL := 2;
    CONSTANT START_CONV_SW_BIT_INDEX : NATURAL := 3;
    CONSTANT BUSY_SW_BIT_INDEX : NATURAL := 4;  
   
    CONSTANT SW_WIDTH : NATURAL := 5 -- 3 bits from DP(Long delay, short delay, reg file), busy, start conversion(btn). Might be others, need to confirm this number;
    CONSTANT CW_WIDTH : NATURAL := 11; -- 4 bits to an7606, 1 bit to reg file, 2 bits to reg count, 2 bits to long delay, 2 bit to short delay. Might be others, need to confirm this number;

    CONSTANT LONG_DELAY_50Mhz_CONST_WIDTH : NATURAL := 24;
    CONSTANT LONG_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(LONG_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"00FFFF";

    CONSTANT SHORT_DELAY_50Mhz_CONST_WIDTH : NATURAL := 8; 
    CONSTANT SHORT_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"10";

    -- You need to determine the 16-bit 2's complement ADC values for these voltages

    -- 16-bit 2's complement ADC values for the following voltages:
    CONSTANT FOURTH_THRESHOLD_CONSTANT : STD_LOGIC_VECTOR(15 downto 0)  := x"10E5";  -- 0.66v*32768/5v = 4325 = 0x10E5
    CONSTANT THIRD_THRESHOLD_CONSTANT  : STD_LOGIC_VECTOR(15 downto 0)   := x"21CA"; -- 1.32v*32768/5v = 8650 = 0x21CA
    CONSTANT SECOND_THRESHOLD_CONSTANT : STD_LOGIC_VECTOR(15 downto 0)  := x"32B0";  -- 1.98*32768/5v = 12976 = 0x32B0
    CONSTANT FIRST_THRESHOLD_CONSTANT  : STD_LOGIC_VECTOR(15 downto 0)   := x"4396"; -- 2.64*32768/5v = 17202 = 0x4396

-- component signalAcquire_Fsm is
-- You need to complete this declaration

-- component signalAcquire_Datapath is
-- You need to complete this declaration


type state_type is (RESET_STATE, LONG_DELAY_STATE, RESET_AD7606_STATE, 
                    WAIT_TRIGGER_STATE, ASSERT_CONVST_STATE, WAIT_BUSY0_STATE, 
                    WAIT_BUSY1_STATE, WAIT_VALID_STATE, LATCH_STATE, PAUSE_STATE, CLEAR_STATE);

component signalAcquire is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   reg0Magnitude: out STD_LOGIC_VECTOR(3 downto 0));				   
end component;	

component an7606_tb IS
    PORT ( clk : in  STD_LOGIC;
           an7606data: out STD_LOGIC_VECTOR(15 downto 0);
           an7606convst, an7606cs, an7606rd, an7606reset: in STD_LOGIC;
           an7606od: in STD_LOGIC_VECTOR(2 downto 0);
           an7606busy : out STD_LOGIC);
END component;
    
    	
end package;


