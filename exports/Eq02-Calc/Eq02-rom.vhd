-- Author: Danilo Fuchs
-- 128x16 ROM

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port (
        clk : in std_logic;
        address : in unsigned(6 downto 0);
        data : out unsigned(15 downto 0)
    );
end entity rom;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant rom_content : mem := (
    0 => b"1000_000_011_000101", --  ADDI R3, R0, #5     -- R3 = 5
    1 => b"1000_000_100_001000", --  ADDI R4, R0, #8     -- R4 = 8
    2 => b"0000_011_100_101_000", -- ADD  R5, R3, R4     -- R5 = R3 + R4    = 13 = 0xD
    3 => b"1000_000_110_000001", --  ADDI R6, R0, #1     -- R6 = 1
    4 => b"0001_101_110_101_000", -- SUB  R5, R5, R6     -- R5 = R5 - R6    = 12 = 0xC
    5 => b"1111_000000010100", --    J    #20
    20 => b"1000_101_011_000000", -- ADDI R3, R5, #0     -- R3 = R5 + 0     = 12 = 0xC
    21 => b"1111_000000000010", --   J    #2
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