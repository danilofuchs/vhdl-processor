-- Author: Danilo Fuchs
-- Control unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
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
end entity control_unit;

architecture a_control_unit of control_unit is

    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;

            state : out unsigned(1 downto 0)
        );
    end component;

    signal state_s : unsigned(1 downto 0);
begin
    state_machine_component : state_machine port map(
        clk => clk,
        rst => rst,
        state => state_s
    );

    -- Program Counter
    pc_wr_en <=
        -- State 2
        '1' when state_s = "10" else
        '0';

    jump_en <=
        -- Type J instructions
        '1' when op_code = "1111" else -- J
        -- Type I, R
        '0';

    branch_en <=
        -- Branch instructions
        '1' when op_code = "1100" else -- BEQ
        '0';

    -- ULA
    ula_op_sel <=
        -- Type R
        "00" when op_code = "0001" else -- ADD
        "01" when op_code = "0010" else -- SUB
        "10" when op_code = "0011" else -- SLT
        -- Type I
        "00" when op_code = "1000" else -- ADDI
        "01" when op_code = "1100" else -- BEQ -- Subtract one from other, check zero flag
        "00";

    ula_src_sel <=
        -- Type I instructions
        '1' when op_code = "1000" else -- ADDI
        -- Branch compares two registers
        '0' when op_code = "1100" else -- BEQ
        -- Type R
        '0';

    -- Regs
    reg_wr_en <=
        -- State 3
        '1' when state_s = "01" and (
        -- Type R
        op_code = "0001" or -- ADD
        op_code = "0010" or -- SUB
        op_code = "0011" or -- SLT
        -- Type I
        op_code = "1000" -- ADDI
        -- DO NOT WRITE ON BRANCHES op_code = "1100" -- BEQ
        ) else
        '0';

    reg_dest_sel <=
        -- Type R instructions
        '1' when op_code = "0001" else -- ADD
        '1' when op_code = "0010" else -- SUB
        '1' when op_code = "0011" else -- SLT
        -- Type I
        '0';

end architecture a_control_unit;