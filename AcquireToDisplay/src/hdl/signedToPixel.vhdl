library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.scopeToHDMI_Package.all;

entity signedToPixel is
    port( 
        signedIn : in  SIGNED(15 downto 0);
        pixelOut : out STD_LOGIC_VECTOR(VIDEO_WIDTH_IN_BITS - 1 downto 0));
    
end entity;

architecture behavior of signedToPixel is
    -- Internal signals declared as signed for math operations
    signal product : signed(31 downto 0);
    signal divided : signed(31 downto 0);
    signal offset  : signed(15 downto 0);
    signal pixel   : signed(15 downto 0);
begin

    -- Multiply 16-bit signed input by screen HEIGHT constant (16-bit signed)
    product <= signedIn * resize(signed(HEIGHT), 16);
    
    -- Fixed-point arithmetic shift right by 16 bits (scales -32768..32767 to -HEIGHT/2..HEIGHT/2)
    divided <= shift_right(product, 16); 
    
    -- Center the waveform vertically on the display (HEIGHT / 2)
   offset <= shift_right(signed(HEIGHT), 1) + signed(T_EDGE);
    
    -- Calculate final vertical pixel coordinate
    pixel <= divided(15 downto 0) + offset(15 downto 0);

    -- Slice out the required bit-width for output
    pixelOut <= std_logic_vector(pixel(VIDEO_WIDTH_IN_BITS - 1 downto 0));

end architecture behavior;