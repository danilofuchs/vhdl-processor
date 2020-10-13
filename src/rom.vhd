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
    -- Equivalent:
    -- #include <stdio.h>

    -- int main(void) {
    --     int a = 0;
    --     for (int i = 0; i < 30; i++) {
    --         a += i;
    --     }
    --     printf("%d", a);
    --     return 0;
    -- }
    constant rom_content : mem := (
    0 => b"1000_000_001_000001", --  ADDI R1, R0, #1     -- R1 = 1
    1 => b"1000_000_010_011110", --  ADDI R2, R0, #30    -- R2 = 30
    2 => b"0001_000_000_011_000", -- ADD  R3, R0, R0     -- R3 = 0
    3 => b"0001_000_000_100_000", -- ADD  R4, R0, R0     -- R4 = 0
    4 => b"0001_011_100_100_000", -- ADD  R4, R3, R4  ** -- R4 = R4 + R3 
    5 => b"0001_011_001_011_000", -- ADD  R3, R3, R1     -- R3 = R3 + R1    = R3 + 1
    6 => b"0011_011_010_110_000", -- SLT  R6, R3, R2     -- R6 = R3 < R2    = R3 < 30
    7 => b"1100_001_110_111100", --  BEQ  R6, R1, #-4    -- if (r6 == 1) { goto -4 }
    8 => b"1000_100_101_000000", --  ADDI  R5, R4, #0    -- R5 = R4
    -- Any other address has 0x0 (NOP)
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