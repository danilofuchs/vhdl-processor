-- Author: Danilo Fuchs
-- ULA - Unidade Lógica Aritmética

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            in_a, in_b : in unsigned(15 downto 0);
            op : in unsigned(1 downto 0);

            out_s : out unsigned(15 downto 0);
            flag : out std_logic
        );
    end component;

    signal in_a_s, in_b_s : unsigned(15 downto 0);
    signal op_s : unsigned(1 downto 0);
    signal out_s_s : unsigned(15 downto 0);
    signal flag_s : std_logic;
begin

    uut : ula port map(
        in_a => in_a_s,
        in_b => in_b_s,
        op => op_s,
        out_s => out_s_s,
        flag => flag_s
    );

    process
    begin
        -- OP
        -- SUM
        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000011"; -- 3
        op_s <= "00"; -- SUM
        -- Expected: 0000000000000011 -- 3 -- 0x0003
        wait for 50 ns;

        in_a_s <= "0000011111010000"; -- 2000
        in_b_s <= "0000011111010000"; -- 2000
        op_s <= "00"; -- SUM
        -- Expected: 111110100000 -- 4000 -- 0x0FA0
        wait for 50 ns;

        -- SUM OVERFLOW:
        in_a_s <= "1111111111111111"; -- 0xFFFF
        in_b_s <= "0000000000000010"; -- 1
        op_s <= "00"; -- SUM
        -- Expected: 00000000000000001 -- 1 -- 0x0001
        wait for 50 ns;

        -- OP
        -- SUBTRACTION
        in_a_s <= "0000011111010000"; -- 2000
        in_b_s <= "0000011111010000"; -- 2000
        op_s <= "01"; -- SUB
        -- Expected: 0000000000000000 -- 0 -- 0x0000
        wait for 50 ns;

        in_a_s <= "0000000000000001"; -- 1
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "01"; -- SUB
        -- Expected: 0000000000000001 -- 1 -- 0x0001
        wait for 50 ns;

        -- SUBTRACTION OVERFLOW:
        in_a_s <= "0000000000000001"; -- 1
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "01"; -- SUB
        -- Expected: 1111111111111111 -- 2^16-1 -- 0xFFFF
        wait for 50 ns;

        -- OP
        -- LESS THAN
        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "10"; -- LT
        -- Expected: flag = 0
        wait for 50 ns;

        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "10"; -- LT
        -- Expected: flag = 1
        wait for 50 ns;

        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "10"; -- LT
        -- Expected: flag = 0
        wait for 50 ns;

        -- OP
        -- GREATER THAN OR EQUAL TO
        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "11"; -- GTE
        -- Expected: flag = 1
        wait for 50 ns;

        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "11"; -- GTE
        -- Expected: flag = 0
        wait for 50 ns;

        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "11"; -- GTE
        -- Expected: flag = 1
        wait for 50 ns;

        wait;
    end process;
end architecture a_ula_tb;