

library ieee;
use ieee.std_logic_1164.all;
use work.basicBuildingBlocks_package.all;


entity EnhancedPWM is
    port(   clk: in STD_LOGIC;
            resetn: in STD_LOGIC;
            enb: in STD_LOGIC;
            dutyCycle: in STD_LOGIC_VECTOR(8 downto 0);
            pwmSignal: out STD_LOGIC;
            pwmCount: out STD_LOGIC_VECTOR(7 downto 0);
            rollover: out STD_LOGIC);
end entity;


architecture structure of EnhancedPWM is
    signal pwmCount_int  : STD_LOGIC_VECTOR(7 downto 0);
    signal pwmCount9Bit  : STD_LOGIC_VECTOR(8 downto 0);
    signal dutyCycle_int : STD_LOGIC_VECTOR(8 downto 0);
    signal dutyGreaterCnt : STD_LOGIC;
    signal counterControl : STD_LOGIC_VECTOR(1 downto 0);
    signal E255:STD_LOGIC;
    
    
begin
    pwmCount9Bit <= '0' & pwmCount_int;
    pwmCount <= pwmCount_int;
    rollOver <= E255;
    
    counterControl <=   "11" when (resetn = '0') else          
                        "00" when (enb = '0') else            
                        "01" when (E255 = '1') else            
                        "10";                                 
    
    dutyCount: genericCounter
        generic Map(N => 8)
        port Map(   d => x"00",
                    clk => clk,
                    resetn => resetn,
                    q => pwmCount_int,
                    c => counterControl
        );
    dutyCompare: genericCompare
        generic Map(N => 9)
        port Map(   x => dutyCycle_int, 
                    y => pwmCount9Bit,
                    g => dutyGreaterCnt,
                    e => open,
                    l => open
                );
        
    rollCompare: genericCompare
        generic Map(N => 8)  
        port Map(   x => x"FF",
                    y => pwmCount_int,
                    e => E255,
                    g => open,
                    l => open
                );
    
    dutyReg: genericRegister
        generic Map(N => 9)
        port Map(   d => dutyCycle,
                    clk => clk,
                    resetn => resetn,
                    q => dutyCycle_int,
                    load => E255
                );

    process(clk)
    begin 
        if(rising_edge(clk)) then
            if(resetn = '0') then 
                pwmSignal <= '0';
            else 
                pwmSignal <= dutyGreaterCnt; 
            end if;
        end if;
    end process; 


end structure;

