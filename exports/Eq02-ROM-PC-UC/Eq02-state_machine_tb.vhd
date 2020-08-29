-- Author: Danilo Fuchs
-- binary state machine

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_machine_tb is
end entity state_machine_tb;

architecture a_state_machine_tb of state_machine_tb is

    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;
            state : out std_logic
        );
    end component;

    signal clk_s, rst_s : std_logic := '0';
    signal state_s : std_logic := '0';

begin

    uut : state_machine port map(
        clk => clk_s,
        rst => rst_s,
        state => state_s
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

        assert state_s = '0' report "state is not 0 initially" severity error;
        wait for 100 ns;
        assert state_s = '1' report "state does not toggle to 1" severity error;

        wait for 300 ns;
        rst_s <= '1';
        wait for 10 ns;
        assert state_s = '0' report "rst not resetting state to 0" severity error;
        wait for 90 ns;
        rst_s <= '0';
        wait;

    end process;

end architecture a_state_machine_tb;