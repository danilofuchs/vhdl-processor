-- Author: Danilo Fuchs
-- ULA + Register File

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_regs is
    port (
        clk : in std_logic;
        rst : in std_logic;
        we : in std_logic;

        imm : in unsigned(15 downto 0); -- Immediate
        imm_en : in std_logic; -- Immediate enable

        -- Selection of registers
        a1 : in unsigned(2 downto 0); -- Read 1
        a2 : in unsigned(2 downto 0); -- Read 2
        a3 : in unsigned(2 downto 0); -- Write

        -- "00" -> sum: a + b
        -- "01" -> subtraction: a - b
        -- "10" -> less than: a < b
        -- "11" -> more than or equals to: a >= b
        op : in unsigned(1 downto 0);

        flag : out std_logic
    );
end entity ula_regs;

architecture a_ula_regs of ula_regs is
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

    component ula
        port (
            in_a : in unsigned(15 downto 0);
            in_b : in unsigned(15 downto 0);
            -- "00" -> sum: a + b
            -- "01" -> subtraction: a - b
            -- "10" -> less than: a < b
            -- "11" -> more than or equals to: a >= b
            op : in unsigned(1 downto 0);

            out_s : out unsigned(15 downto 0);
            flag : out std_logic
        );
    end component;

    signal wd3_s, rd2_s, in_a_s, in_b_s : unsigned(15 downto 0) := "0000000000000000";

begin
    regs_component : register_file port map(
        clk => clk,
        rst => rst,
        we3 => we,
        wd3 => wd3_s, -- Connected to out_s of ULA
        a1 => a1,
        a2 => a2,
        a3 => a3,
        rd1 => in_a_s,
        rd2 => rd2_s -- Connected to MUX
    );

    ula_component : ula port map(
        out_s => wd3_s,
        in_a => in_a_s,
        in_b => in_b_s,
        op => op,
        flag => flag
    );

    -- MUX
    in_b_s <= imm when imm_en = '1' else
        rd2_s;

end architecture a_ula_regs;