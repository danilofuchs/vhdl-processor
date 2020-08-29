-- Author: Danilo Fuchs
-- 128x12 ROM

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port (
        clk : in std_logic;
        address : in unsigned(6 downto 0);
        data : out unsigned(11 downto 0)
    );
end entity rom;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(11 downto 0);
    constant rom_content : mem := (
    0 => "000000000010",
    1 => "100000000000",
    2 => "000000000000",
    3 => "000000000000",
    4 => "100000000000",
    5 => "000000000010",
    6 => "111100000011",
    7 => "000000000010",
    8 => "000000000010",
    9 => "000000000000",
    10 => "000000000000",
    -- Any other address has 0x0
    others => (others => '0')
    );

begin
    process (clk)
    begin
        if rising_edge(clk) then
            data <= rom_content(to_integer(address));
        end if;
    end process;

end architecture a_rom;