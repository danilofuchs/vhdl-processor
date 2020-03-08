library IEEE;
use IEEE.std_logic_1164.all;

-- Code: Modern VHDL, VHDL Formatter, VHDL LS
-- Tools: ghdl, gtkwave

entity ports is
    port (
        in_a : in std_logic;
        in_b : in std_logic;

        a_and_b : out std_logic
    );
end entity ports;

architecture a_ports of ports is
begin
    a_and_b <= in_a and in_b;
end architecture a_ports;