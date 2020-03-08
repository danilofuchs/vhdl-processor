library IEEE;
use IEEE.std_logic_1164.all;

entity ports_tb is
end;

architecture a_ports_tb of ports_tb is
    component ports
        port (
            in_a : in std_logic;
            in_b : in std_logic;

            a_and_b : out std_logic
        );
    end component;

    signal in_a_s, in_b_s, a_and_b_s : std_logic;

begin

    uut : ports port map(
        in_a => in_a_s,
        in_b => in_b_s,
        a_and_b => a_and_b_s);

    process
    begin
        in_a_s <= '0';
        in_b_s <= '0';
        wait for 50 ns;
        in_a_s <= '0';
        in_b_s <= '1';
        wait for 50 ns;
        in_a_s <= '1';
        in_b_s <= '0';
        wait for 50 ns;
        in_a_s <= '1';
        in_b_s <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture a_ports_tb;