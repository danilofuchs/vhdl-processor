-- Author: Danilo Fuchs
-- ULA + Register File

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_regs_tb is
end;

architecture a_ula_regs_tb of ula_regs_tb is
    component ula_regs
        port (
            clk : in std_logic;
            rst : in std_logic;
            we : in std_logic;

            imm : in unsigned(15 downto 0); -- Immediate
            imm_en : in std_logic; -- Immediate enable

            -- Selection of registers
            a1 : in unsigned(2 downto 0); -- Read 1
            a2 : in unsigned(2 downto 0); -- Read 2
            a3 : in unsigned(2 downto 0); -- Write

            -- "00" -> sum: a + b
            -- "01" -> subtraction: a - b
            -- "10" -> less than: a < b
            -- "11" -> more than or equals to: a >= b
            op : in unsigned(1 downto 0);

            flag : out std_logic
        );
    end component;

    signal clk_s, rst_s, we_s, imm_en_s : std_logic := '0';
    signal imm_s : unsigned(15 downto 0) := "0000000000000000";
    signal a1_s, a2_s, a3_s : unsigned(2 downto 0) := "000";
    signal op_s : unsigned(1 downto 0) := "00";
    signal flag_s : std_logic := '0';
begin

    uut : ula_regs port map(
        clk => clk_s,
        rst => rst_s,
        we => we_s,

        imm => imm_s,
        imm_en => imm_en_s,

        a1 => a1_s,
        a2 => a2_s,
        a3 => a3_s,

        op => op_s,
        flag => flag_s
    );

    process -- clock process
    begin
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        -- Reset
        rst_s <= '1';
        wait for 100 ns;
        rst_s <= '0';

        we_s <= '1';
        imm_en_s <= '1';

        -- Write 0x0001 to register R1
        -- R1 = 0x0000 + 0x0001
        wait for 100 ns;
        we_s <= '1';
        imm_en_s <= '1';
        imm_s <= "0000000000000001";
        a1_s <= "000";
        a3_s <= "001";
        op_s <= "00";

        -- Write 0x0002 to register R2
        -- R3 = 0x0000 + 0x0002
        wait for 100 ns;
        we_s <= '1';
        imm_en_s <= '1';
        imm_s <= "0000000000000010";
        a1_s <= "000";
        a3_s <= "010";
        op_s <= "00";

        -- R3 = R2 - R1 == 0x0001
        wait for 100 ns;
        we_s <= '1';
        imm_en_s <= '0';
        imm_s <= "0000000000000000";
        a1_s <= "010";
        a2_s <= "001";
        a3_s <= "011";
        op_s <= "01";

        -- R2 >= R1 == 1
        wait for 100 ns;
        we_s <= '0';
        a1_s <= "010";
        a2_s <= "001";
        op_s <= "11";

        -- Reset
        wait for 100 ns;
        rst_s <= '1';
        wait;

    end process;
end architecture a_ula_regs_tb;