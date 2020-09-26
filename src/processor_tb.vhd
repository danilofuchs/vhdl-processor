-- Author: Danilo Fuchs	
-- 16 bits program counter (PC)	

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor_tb is
end;

architecture a_processor_tb of processor_tb is
    component processor
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    signal clk_s, rst_s : std_logic := '0';
begin

    uut : processor port map(
        clk => clk_s,
        rst => rst_s
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

    process
    begin
        wait;
    end process;
end architecture a_processor_tb;