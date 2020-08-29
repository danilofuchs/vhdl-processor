-- Author: Danilo Fuchs
-- 16 bits program counter (PC)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter_tb is
end;

architecture a_program_counter_tb of program_counter_tb is
    component program_counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            count : out unsigned(15 downto 0)
        );
    end component;

    signal clk_s, rst_s : std_logic := '0';
    signal count_s : unsigned(15 downto 0) := "0000000000000000";
begin

    uut : program_counter port map(
        clk => clk_s,
        rst => rst_s,
        count => count_s
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

        assert count_s = "0000000000000000" report "should start at count 0x0" severity error;
        wait for 100 ns;
        assert count_s = "0000000000000001" report "should increment to 0x1" severity error;
        wait for 100 ns;
        assert count_s = "0000000000000010" report "should increment to 0x2" severity error;

        wait;
    end process;
end architecture a_program_counter_tb;