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

            result : out unsigned(15 downto 0);
            zero_flag : out std_logic
        );
    end component;

    signal in_a_s, in_b_s : unsigned(15 downto 0) := "0000000000000000";
    signal op_s : unsigned(1 downto 0) := "00";
    signal result_s : unsigned(15 downto 0) := "0000000000000000";
    signal zero_flag_s : std_logic := '0';
begin

    uut : ula port map(
        in_a => in_a_s,
        in_b => in_b_s,
        op => op_s,
        result => result_s,
        zero_flag => zero_flag_s
    );

    process
    begin
        -- OP
        -- SUM
        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000011"; -- 3
        op_s <= "00"; -- SUM
        wait for 50 ns;
        -- Expected: 0000000000000011 -- 3 -- 0x0003
        assert result_s = "0000000000000011" report "0 + 3 != 3" severity error;

        in_a_s <= "0000011111010000"; -- 2000
        in_b_s <= "0000011111010000"; -- 2000
        op_s <= "00"; -- SUM
        wait for 50 ns;
        -- Expected: 0000111110100000 -- 4000 -- 0x0FA0
        assert result_s = "0000111110100000" report "2000 + 2000 != 4000" severity error;

        -- SUM OVERFLOW:
        in_a_s <= "1111111111111111"; -- 0xFFFF
        in_b_s <= "0000000000000010"; -- 1
        op_s <= "00"; -- SUM
        wait for 50 ns;
        -- Expected: 00000000000000001 -- 1 -- 0x0001
        assert result_s = "00000000000000001" report "Incorrect sum overflow" severity error;

        -- OP
        -- SUBTRACTION
        in_a_s <= "0000011111010000"; -- 2000
        in_b_s <= "0000011111010000"; -- 2000
        op_s <= "01"; -- SUB
        wait for 50 ns;
        -- Expected: 0000000000000000 -- 0 -- 0x0000
        assert result_s = "0000000000000000" report "2000 - 2000 != 0" severity error;
        assert zero_flag_s = '1' report "Flag zero should be set" severity error;

        in_a_s <= "0000000000000001"; -- 1
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "01"; -- SUB
        wait for 50 ns;
        -- Expected: 0000000000000001 -- 1 -- 0x0001
        assert result_s = "0000000000000001" report "1 - 0 != 1" severity error;
        assert zero_flag_s = '0' report "Flag zero should not be set" severity error;

        -- SUBTRACTION OVERFLOW:
        in_a_s <= "0000000000000001"; -- 1
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "01"; -- SUB
        wait for 50 ns;
        -- Expected: 1111111111111111 -- 2^16-1 -- 0xFFFF
        assert result_s = "1111111111111111" report "Incorrect subtraction overflow" severity error;
        assert zero_flag_s = '0' report "Flag zero should not be set" severity error;

        -- OP
        -- LESS THAN
        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "10"; -- LT
        wait for 50 ns;
        -- Expected: false
        assert result_s = "0000000000000000" report "2 < 0 should be false" severity error;

        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "10"; -- LT
        wait for 50 ns;
        -- Expected: true
        assert result_s = "0000000000000001" report "0 < 2 should be true" severity error;

        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "10"; -- LT
        wait for 50 ns;
        -- Expected: false
        assert result_s = "0000000000000000" report "2 < 2 should be false" severity error;

        -- OP
        -- GREATER THAN OR EQUAL TO
        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000000"; -- 0
        op_s <= "11"; -- GTE
        wait for 50 ns;
        -- Expected: true
        assert result_s = "0000000000000001" report "2 >= 0 should be true" severity error;

        in_a_s <= "0000000000000000"; -- 0
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "11"; -- GTE
        wait for 50 ns;
        -- Expected: false
        assert result_s = "0000000000000000" report "0 >= 2 should be false" severity error;

        in_a_s <= "0000000000000010"; -- 2
        in_b_s <= "0000000000000010"; -- 2
        op_s <= "11"; -- GTE
        wait for 50 ns;
        -- Expected: true
        assert result_s = "0000000000000001" report "2 >= 2 should be true" severity error;

        wait;
    end process;
end architecture a_ula_tb;