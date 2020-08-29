# Author: Danilo Fuchs
# Makefile to be used with 'make' command

ula:
	ghdl -a src/ula.vhd
	ghdl -e ula
	ghdl -a src/ula_tb.vhd
	ghdl -e ula_tb
	ghdl -r ula_tb --wave=src/ula_tb.ghw

reg16bits:
	ghdl -a src/reg16bits.vhd
	ghdl -e reg16bits
	ghdl -a src/reg16bits_tb.vhd
	ghdl -e reg16bits_tb
	ghdl -r reg16bits_tb --stop-time=3000ns --wave=src/reg16bits_tb.ghw

register_file:
	make reg16bits
	ghdl -a src/register_file.vhd
	ghdl -e register_file
	ghdl -a src/register_file_tb.vhd
	ghdl -e register_file_tb
	ghdl -r register_file_tb --stop-time=3000ns --wave=src/register_file_tb.ghw

ula_regs:
	make ula
	make register_file
	ghdl -a src/ula_regs.vhd
	ghdl -e ula_regs
	ghdl -a src/ula_regs_tb.vhd
	ghdl -e ula_regs_tb
	ghdl -r ula_regs_tb --stop-time=3000ns --wave=src/ula_regs_tb.ghw

rom:
	ghdl -a src/rom.vhd
	ghdl -e rom
	ghdl -a src/rom_tb.vhd
	ghdl -e rom_tb
	ghdl -r rom_tb --stop-time=3000ns --wave=src/rom_tb.ghw

state_machine:
	ghdl -a src/state_machine.vhd
	ghdl -e state_machine
	ghdl -a src/state_machine_tb.vhd
	ghdl -e state_machine_tb
	ghdl -r state_machine_tb --stop-time=3000ns --wave=src/state_machine_tb.ghw

program_counter:
	make reg16bits
	ghdl -a src/program_counter.vhd
	ghdl -e program_counter
	ghdl -a src/program_counter_tb.vhd
	ghdl -e program_counter_tb
	ghdl -r program_counter_tb --stop-time=3000ns --wave=src/program_counter_tb.ghw

control_unit:
	make rom
	make program_counter
	ghdl -a src/control_unit.vhd
	ghdl -e control_unit
	ghdl -a src/control_unit_tb.vhd
	ghdl -e control_unit_tb
	ghdl -r control_unit_tb --stop-time=3000ns --wave=src/control_unit_tb.ghw