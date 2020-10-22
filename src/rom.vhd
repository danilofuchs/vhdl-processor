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
    --     int a = 30;
    --     int a = a + 1;
    -- }
    constant rom_content : mem := (
    0 => b"1000_000_001_000010", --  ADDI R1, R0, #2     -- R1 = 2
    1 => b"1000_000_010_011110", --  ADDI R2, R0, #30    -- R2 = 30
    2 => b"0100_001_010_000000", --  SW   R2, (R1)       -- RAM[R1] = R2 = 30
    3 => b"1000_001_001_000001", --  ADDI R1, R1, #1     -- R1 = R1 + 1 = 3
    4 => b"1000_010_010_010100", --  ADDI R2, R2, #20    -- R2 = R2 + 20 = 50
    5 => b"0100_001_010_000000", --  SW   R2, (R1)       -- RAM[R1] = R2 = 30
    6 => b"1000_000_001_000010", --  ADDI R1, R0, #2     -- R1 = 2
    7 => b"0101_001_010_000000", --  LW   R2, (R1)       -- R2 = RAM[R1] = 30
    8 => b"1000_000_101_001010", --  ADDI R5, R0, #10    -- R5 = 10
    9 => b"1000_000_011_111111", --  ADDI R3, R0, #63    -- R3 = 63
    10 => b"0100_101_011_000000", -- SW   R3, (R5)       -- RAM[R5] = R3 = 63
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