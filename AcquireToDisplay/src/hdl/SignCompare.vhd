library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signedCompare is
    generic(N: integer := 16);
    port(
        x, y : in std_logic_vector(N-1 downto 0);
        g, l, e : out std_logic
    );
end signedCompare;

architecture behavior of signedCompare is
begin

    process(x, y)
    begin
        g <= '0';
        l <= '0';
        e <= '0';
        if x(N-1) = '0' and y(N-1) = '1' then
            g <= '1';
        elsif x(N-1) = '1' and y(N-1) = '0' then
            l <= '1';
        elsif signed(x) > signed(y) then
            g <= '1';
        elsif signed(x) < signed(y) then
            l <= '1';
        else
            e <= '1';

        end if;
    end process;

end behavior;