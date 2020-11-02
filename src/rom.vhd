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
        0 => b"1000_000_001_000001", --  ADDI R1, R0, #1     -- R1 = 1  -- Data
        1 => b"1000_000_010_100001", --  ADDI R2, R0, #33    -- R2 = 33 -- Array size + 1
        2 => b"1000_000_011_000001", --  ADDI R3, R0, #1     -- R3 = 1  -- Index (i)
        3 => b"1000_000_111_000001", --  ADDI R7, R0, #1     -- R7 = 1  -- const 1

        4 => b"0100_011_001_000000", --  seed: SW R1, (R3)         -- mem[R3] = R1    -- mem[i] = data = 1
        5 => b"1000_011_011_000001", --        ADDI R3, R3, #1     -- R3++            -- i++
        6 => b"0011_011_010_100_000", --       SLT  R4, R3, R2     -- R4 = R3 < R2    -- i < 33
        7 => b"1100_100_111_111100", --        BEQ  R4, R7, #-4    -- if (r4 == 1) { goto seed (-4) }

        8 => b"1000_000_001_000000", --  ADDI  R1, R0, #0       -- R1 = 0   -- data = 0

        9 => b"1000_000_011_000100", --  ADDI  R3, R0, #4          -- R3 = 4          -- i = 4
        10 => b"0100_011_001_000000", -- rm2:  SW   R1, (R3)       -- mem[R3] = R1    -- mem[i] = data = 0
        11 => b"1000_011_011_000010", --       ADDI R3, R3, #2     -- R3 += 2         -- i += 2
        12 => b"0011_011_010_100_000", --      SLT  R4, R3, R2     -- R4 = R3 < R2    -- i < 33
        13 => b"1100_100_111_111100", --       BEQ  R4, R7, #-4    -- if (r4 == 1) { goto rm2 (-4) }

        14 => b"1000_000_011_001001", -- ADDI  R3, R0, #9          -- R3 = 9          -- i = 9
        15 => b"0100_011_001_000000", -- rm3:  SW   R1, (R3)       -- mem[R3] = R1    -- mem[i] = data = 0
        16 => b"1000_011_011_000011", --       ADDI R3, R3, #3     -- R3 += 3         -- i += 3
        17 => b"0011_011_010_100_000", --      SLT  R4, R3, R2     -- R4 = R3 < R2    -- i < 33
        18 => b"1100_100_111_111100", --       BEQ  R4, R7, #-4    -- if (r4 == 1) { goto rm3 (-4) }

        19 => b"1000_000_011_011001", -- ADDI  R3, R0, #25         -- R3 = 25         -- i = 25
        20 => b"0100_011_001_000000", -- rm5:  SW   R1, (R3)       -- mem[R3] = R1    -- mem[i] = data = 0
        21 => b"1000_011_011_000101", --       ADDI R3, R3, #5     -- R3 += 5         -- i += 5
        22 => b"0011_011_010_100_000", --      SLT  R4, R3, R2     -- R4 = R3 < R2    -- i < 33
        23 => b"1100_100_111_111100", --       BEQ  R4, R7, #-4    -- if (r4 == 1) { goto rm5 (-4) }

        24 => b"1000_000_011_000001", -- ADDI  R3, R0, #1          -- R3 = 1         -- i = 1
        25 => b"1000_000_101_111111", -- ADDI  R5, R0, #63         -- R5 = 63
        26 => b"1000_101_101_111111", -- ADDI  R5, R5, #63         -- R5 += 63 = 126
        27 => b"1000_101_101_000001", -- ADDI  R5, R5, #1          -- R5 += 1  = 127
        28 => b"1000_011_011_000001", -- prt:  ADDI R3, R3, #1     -- R3 = R3 + 1    -- i++
        29 => b"0101_011_001_000000", --       LW   R1, (R3)       -- R1 = mem[R3]
        30 => b"0100_101_001_000000", --       SW   R1, (R5)       -- mem[R5] = R1   -- mem[127] = data
        31 => b"1100_011_010_000011", --       BEQ  R3, R2, #3     -- if (r3 == 63) { goto +3 }
        32 => b"1111_000000011100", --         J  prt              -- goto prt
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