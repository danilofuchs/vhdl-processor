-- Author: Danilo Fuchs
-- 8x16 register file

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file_tb is

end entity register_file_tb;

architecture a_register_file_tb of register_file_tb is
    component register_file
        port (
            clk : in std_logic;
            rst : in std_logic;
            we3 : in std_logic;

            a1 : in unsigned(2 downto 0);
            a2 : in unsigned(2 downto 0);
            a3 : in unsigned(2 downto 0);

            wd3 : in unsigned(15 downto 0);
            rd1 : out unsigned(15 downto 0);
            rd2 : out unsigned(15 downto 0)
        );
    end component;

    signal clk_s, rst_s, we3_s : std_logic;
    signal a1_s, a2_s, a3_s : unsigned(2 downto 0);
    signal wd3_s, rd1_s, rd2_s : unsigned(15 downto 0);

begin

    uut : register_file port map(
        clk => clk_s,
        rst => rst_s,
        we3 => we3_s,
        a1 => a1_s,
        a2 => a2_s,
        a3 => a3_s,
        wd3 => wd3_s,
        rd1 => rd1_s,
        rd2 => rd2_s
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
        -- reset all registers
        rst_s <= '1';
        we3_s <= '0';
        wait for 100 ns;
        rst_s <= '0';
        wait for 100 ns;

        a3_s <= "001";
        we3_s <= '1';
        wd3_s <= "1010101010101010";
        a1_s <= "001";
        wait for 100 ns;
        we3_s <= '0';
        assert rd1_s = "1010101010101010" report "Should write value to register 1" severity error;
        wait for 100 ns;

        a3_s <= "010";
        we3_s <= '1';
        wd3_s <= "0101010101010101";
        a1_s <= "010";
        wait for 100 ns;
        we3_s <= '0';
        assert rd1_s = "0101010101010101" report "Should write value to register 2" severity error;
        wait for 100 ns;

        a3_s <= "000";
        we3_s <= '1';
        wd3_s <= "0000111100001111";
        a1_s <= "000";
        wait for 100 ns;
        we3_s <= '0';
        assert rd1_s = "00000000000000000" report "Should maintain value 0x0 in register 0" severity error;
        wait for 100 ns;

        a1_s <= "001";
        a2_s <= "010";
        wait for 100 ns;
        assert rd1_s = "1010101010101010" and rd2_s = "0101010101010101" report "Should read 2 values at the same time" severity error;
        wait for 100 ns;

        rst_s <= '1';
        a1_s <= "001";
        a2_s <= "010";
        wait for 100 ns;
        rst_s <= '0';
        assert rd1_s = "0000000000000000" and rd2_s = "0000000000000000" report "Should clear all registers on rst" severity error;
        wait for 100 ns;

        a3_s <= "011";
        a1_s <= "011";
        we3_s <= '1';
        wd3_s <= "0011001100110011";
        wait for 20 ns;
        we3_s <= '0';
        assert rd1_s = "0000000000000000" report "Should not write on clock low, no rising edge" severity error;
        wait for 30 ns;

        a3_s <= "011";
        a1_s <= "011";
        we3_s <= '1';
        wd3_s <= "0011001100110011";
        wait for 20 ns;
        we3_s <= '0';
        assert rd1_s = "0000000000000000" report "Should not write on clock high, no rising edge" severity error;
        wait for 20 ns;

        a3_s <= "011";
        a1_s <= "011";
        we3_s <= '1';
        wd3_s <= "0011001100110011";
        wait for 25 ns;
        we3_s <= '0';
        assert rd1_s = "0000000000000000" report "Should not write on falling edge" severity error;
        wait for 85 ns;

        wait;
    end process;
end architecture a_register_file_tb;