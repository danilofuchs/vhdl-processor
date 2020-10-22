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

        -- Selects between available ULA operations
        ula_op_sel : out unsigned(1 downto 0);
        -- Selects if ULA should get value A from instruction ('1') or from register ('0')
        ula_src_sel : out std_logic;

        -- Changes between rd ('1') and rt ('0')
        reg_dest_sel : out std_logic;
        -- Enables write of registers
        reg_wr_en : out std_logic;

        -- Selects if will use value from memory ('1') or ULA ('0') to write to register file
        mem_to_reg_sel : out std_logic;
        -- Enables writes on memory
        mem_wr_en : out std_logic
    );
end entity control_unit;

architecture a_control_unit of control_unit is

    component state_machine
        port (
            clk : in std_logic;
            rst : in std_logic;

            -- 00 = FETCH
            -- 01 = DECODE
            -- 10 = EXECUTION
            -- 11 = MEMORY ACCESS
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
        -- Branch compares two registers (just like type R)
        '0' when op_code = "1100" else -- BEQ
        -- Type R
        '0';

    -- Regs
    reg_wr_en <=
        -- State 3 - Write to registers
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
        -- RAM
        '0' when op_code = "0100" else -- SW
        -- Type I
        '0';

    -- RAM
    mem_to_reg_sel <=
        '0';

    mem_wr_en <=
        '1' when state_s = "11" -- STATE 4
        and op_code = "0100" else -- SW
        '0';
end architecture a_control_unit;