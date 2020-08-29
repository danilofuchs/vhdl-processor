-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit_tb is
end;

architecture a_control_unit_tb of control_unit_tb is
    component control_unit
        port (
            clk : in std_logic;
            rst : in std_logic;
            data : out unsigned(11 downto 0)
        );
    end component;

    signal clk_s, rst_s : std_logic := '0';
    signal data_s : unsigned(11 downto 0) := "000000000000";
begin

    uut : control_unit port map(
        clk => clk_s,
        rst => rst_s,
        data => data_s
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

        wait;
    end process;
end architecture a_control_unit_tb;