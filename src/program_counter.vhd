-- Author: Danilo Fuchs
-- 16 bits program counter (PC)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        count : out unsigned(15 downto 0)
    );
end entity program_counter;

architecture a_program_counter of program_counter is
    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_in_s, data_out_s : unsigned(15 downto 0) := "0000000000000000";
begin

    pc : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_in => data_in_s,
        data_out => data_out_s
    );

    data_in_s <= data_out_s + 1;
    count <= data_out_s;

end architecture a_program_counter;