----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.hdmi_package.all;


package acquireToHDMI_package is


-- Clock period definitions
CONSTANT clk_period : time := 20 ns;			-- 50Mhz crystal input (XTL_IN).

-- You need to complete this
type state_type is (RESET_STATE);


---------------------------- CONTROL WORD -----------------------------
CONSTANT CW_WIDTH : NATURAL := xx;
CONSTANT CONTROL_CW_WIDTH : NATURAL := xx;

CONSTANT CLEAR_STORE_FLAG_CW_BIT_INDEX : NATURAL := 21;
CONSTANT SET_STORE_FLAG_CW_BIT_INDEX : NATURAL := 20;

---------------------------- STATUS WORD -----------------------------
CONSTANT SW_WIDTH : NATURAL := xx;
CONSTANT DATAPATH_SW_WIDTH : NATURAL := xx;
CONSTANT FORCED_MODE_SW_BIT_INDEX : NATURAL := 9;


CONSTANT LONG_DELAY_50Mhz_CONST_WIDTH : NATURAL := 24;
CONSTANT LONG_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(LONG_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"00FFFF";

CONSTANT SHORT_DELAY_50Mhz_CONST_WIDTH : NATURAL := 8; 
CONSTANT SHORT_DELAY_50Mhz_COUNTS : STD_LOGIC_VECTOR(SHORT_DELAY_50Mhz_CONST_WIDTH - 1 downto 0) := x"10";

CONSTANT HIGHEST_RATE   : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(300, 32));
CONSTANT HIGH_RATE      : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(600, 32));
CONSTANT LOWEST_RATE    : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(1200, 32));
CONSTANT LOW_RATE       : STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(2400, 32));

component acquireToHDMI_fsm is
end component;

component acquireToHDMI_datapath is
end component;

component acquireToHDMI is
end component;	

component an7606 is
    PORT ( clk : in  STD_LOGIC;
           an7606data: out STD_LOGIC_VECTOR(15 downto 0);
           an7606convst, an7606cs, an7606rd, an7606reset: in STD_LOGIC;
           an7606od: in STD_LOGIC_VECTOR(2 downto 0);
           an7606busy : out STD_LOGIC);
END component;

component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END component;

end package;
