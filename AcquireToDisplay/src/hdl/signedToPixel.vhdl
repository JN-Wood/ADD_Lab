library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;
use work.scopeToHDMI_Package.all;

entity signedToPixel is
    port(   signedIn : in STD_LOGIC_VECTOR(15 downto 0);
            pixelOut: out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS -1 downto 0)
        );
end entity;

architecture behavior of signedToPixel is

    signal product : STD_LOGIC_VECTOR(31 downto 0);
    signal divided : STD_LOGIC_VECTOR(31 downto 0);
begin
    product <= signed(signedIn) * signed(HEIGHT);
    divided <= shift_right(product, 16);    
    pixelOut <= unsigned(divided(15 downto 0) + signed(HEIGHT), VIDEO_WIDTH_IN_BITS);

end behavior;    

