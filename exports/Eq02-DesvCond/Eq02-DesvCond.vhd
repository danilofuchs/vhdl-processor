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
            branch_en : out std_logic;

            ula_op_sel : out unsigned(1 downto 0);
            ula_src_sel : out std_logic;

            -- Changes between rd and rt
            reg_dest_sel : out std_logic;
            reg_wr_en : out std_logic
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

            result : out unsigned(15 downto 0);
            zero_flag : out std_logic
        );
    end component ula;

    signal instruction_s : unsigned(15 downto 0) := "0000000000000000";

    -- PC
    signal pc_in_s, pc_out_s : unsigned(15 downto 0) := "0000000000000000";
    signal jump_en_s, branch_en_s, pc_wr_en_s : std_logic := '0';
    signal pc_src_s : unsigned(1 downto 0) := "00";

    -- ULA
    signal ula_op_sel_s : unsigned(1 downto 0) := "00";
    signal ula_src_sel_s : std_logic;
    signal ula_zero_flag_s : std_logic;
    signal ula_in_b_s : unsigned(15 downto 0);

    -- Regs
    signal rd1_s, rd2_s, wd3_s : unsigned(15 downto 0);
    signal reg_dest_sel_s, reg_wr_en_s : std_logic;
    signal a3_s : unsigned(2 downto 0);

    -- Instruction decoding
    signal rs_s, rt_s, rd_s : unsigned(2 downto 0);
    signal imm_s : unsigned(5 downto 0);

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
        pc_wr_en => pc_wr_en_s,
        branch_en => branch_en_s,

        ula_op_sel => ula_op_sel_s,
        ula_src_sel => ula_src_sel_s,

        reg_dest_sel => reg_dest_sel_s,
        reg_wr_en => reg_wr_en_s
    );

    regs_component : register_file port map(
        clk => clk,
        rst => rst,

        we3 => reg_wr_en_s,
        wd3 => wd3_s,

        a1 => rs_s,
        a2 => rt_s,
        a3 => a3_s, -- rd (type R ops) or rt (type I ops)

        rd1 => rd1_s,
        rd2 => rd2_s
    );

    ula_component : ula port map(
        in_a => rd1_s,
        in_b => ula_in_b_s,

        op => ula_op_sel_s,
        result => wd3_s,
        zero_flag => ula_zero_flag_s
    );

    rs_s <= instruction_s(11 downto 9);
    rt_s <= instruction_s(8 downto 6);
    rd_s <= instruction_s(5 downto 3);
    imm_s <= instruction_s(5 downto 0);

    a3_s <=
        -- Type R
        rd_s when reg_dest_sel_s = '1' else
        -- Type I
        rt_s;

    ula_in_b_s <=
        -- Type I
        "0000000000" & imm_s when ula_src_sel_s = '1' else
        -- Type R
        rd2_s;

    pc_src_s <=
        "01" when branch_en_s = '1' and ula_zero_flag_s = '1' else
        "10" when jump_en_s = '1' else
        "00";

    pc_in_s <=
        -- Branch
        pc_out_s + unsigned(resize(signed(imm_s), 16)) + 1 -- Needs to be resized to overflow correctly (negative numbers)
        when pc_src_s = "01" else
        -- Jump
        "0000" & instruction_s(11 downto 0) when pc_src_s = "10" else
        -- Default
        pc_out_s + 1;

end architecture a_processor;