-- Author: Danilo Fuchs
-- Processor. Combines ULA, PC, Control Unit, ROM and MUXs

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity processor;
architecture a_processor of processor is

    component rom
        port (
            clk : in std_logic;
            address : in unsigned(6 downto 0);
            data : out unsigned(15 downto 0)
        );
    end component rom;

    component reg16bits
        port (
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component reg16bits;

    component control_unit is
        port (
            clk : in std_logic;
            rst : in std_logic;

            op_code : in unsigned(3 downto 0);

            jump_en : out std_logic;
            pc_wr_en : out std_logic;

            ula_op : out unsigned(1 downto 0);
            ula_en : out std_logic
        );
    end component control_unit;

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
    end component register_file;

    component ula is
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
    end component ula;

    signal instruction_s : unsigned(15 downto 0) := "0000000000000000";

    signal pc_in_s, pc_out_s : unsigned(15 downto 0) := "0000000000000000";
    signal jump_en_s, pc_wr_en_s : std_logic := '0';

    signal ula_op_s : unsigned(1 downto 0) := "00";
    signal ula_flag_s : std_logic;

    signal rd1_s, rd2_s, wd3_s : unsigned(15 downto 0);

begin
    pc_component : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => pc_wr_en_s,
        data_in => pc_in_s,

        data_out => pc_out_s
    );

    rom_component : rom port map(
        clk => clk,
        address => pc_out_s(6 downto 0),

        data => instruction_s
    );

    control_unit_component : control_unit port map(
        clk => clk,
        rst => rst,
        op_code => instruction_s(15 downto 12),

        jump_en => jump_en_s,
        pc_wr_en => pc_wr_en_s
    );

    regs_component : register_file port map(
        clk => clk,
        rst => rst,

        we3 => '1', -- TODO: Disable conditionally
        wd3 => wd3_s,

        a1 => instruction_s(10 downto 8),
        a2 => instruction_s(6 downto 4),
        a3 => instruction_s(2 downto 0),

        rd1 => rd1_s,
        rd2 => rd2_s
    );

    ula_component : ula port map(
        in_a => rd1_s,
        in_b => rd2_s, -- TODO: Get from immediate

        op => ula_op_s,
        out_s => wd3_s,
        flag => ula_flag_s
    );

    pc_in_s <=
        "0000" & instruction_s(11 downto 0) when jump_en_s = '1' else
        pc_out_s + 1;

end architecture a_processor;