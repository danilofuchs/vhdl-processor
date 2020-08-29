-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port (
        clk : in std_logic;
        rst : in std_logic;
        data : out unsigned(11 downto 0)
    );
end entity control_unit;

architecture a_control_unit of control_unit is
    component rom
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(11 downto 0)
        );
    end component;

    component program_counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            count : out unsigned(15 downto 0)
        );
    end component;

    signal count_s : unsigned(15 downto 0);
    signal address_s : unsigned(6 downto 0);
    signal data_s : unsigned(11 downto 0);
begin

    pc_component : program_counter port map(
        clk => clk,
        rst => rst,
        count => count_s
    );

    rom_component : rom port map(
        clk => clk,
        address => address_s,
        data => data_s
    );

    address_s <= count_s (6 downto 0);
    data <= data_s;

end architecture a_control_unit;