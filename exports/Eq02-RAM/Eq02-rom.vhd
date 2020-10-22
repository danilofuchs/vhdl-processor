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
    -- int main(void) {
    --     int i = 0;
    --     int a = 251;
    --     int vec[127];
    --     do {
    --         a = a - 1;
    --         vec[i] = a;
    --         i = i + 1;
    --     } while(123 < a)
    -- }
    constant rom_content : mem := (
    0 => b"1000_000_001_000000", --  ADDI R1, R0, #0     -- R1 = 0 -- Address
    1 => b"1000_000_011_000001", --  ADDI R3, R0, #1     -- R3 = 1 -- Constant to compare later
    2 => b"1000_000_100_111111", --  ADDI R4, R0, #63    -- R4 = 63 -- Lower limit
    3 => b"1000_100_100_111100", --  ADDI R4, R0, #60    -- R4 = R4 + 60 = 123
    4 => b"1000_000_010_111111", --  ADDI R2, R0, #63    -- R2 = 63 -- Value to store
    5 => b"1000_010_010_111111", --  ADDI R2, R2, #63    -- R2 = R2 + 63 = 126
    6 => b"1000_010_010_111111", --  ADDI R2, R2, #63    -- R2 = R2 + 63 = 189
    7 => b"1000_010_010_111110", --  ADDI R2, R2, #62    -- R2 = R2 + 62 = 251
    8 => b"0010_010_011_010_000", -- SUB  R2, R2, R3  ** -- R2 = R2 - R3 = R2 - 1
    9 => b"0100_001_010_000000", --  SW   R2, (R1)       -- RAM[R1] = R2 = 250, 249, ...
    10 => b"1000_001_001_000001", -- ADDI R1, R1, #1     -- R1 = R1 + 1
    11 => b"0011_100_010_110_000", --SLT  R6, R4, R2     -- R6 = R4 < R2 = 123 < R4
    12 => b"1100_011_110_111011", -- BEQ  R6, R3, #-5    -- if (r6 == 1) { goto -5 }
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