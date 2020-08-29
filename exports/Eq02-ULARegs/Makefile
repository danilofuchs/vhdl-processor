# Author: Danilo Fuchs
# Makefile to be used with 'make' command

ula:
	ghdl -a src/ula.vhd
	ghdl -e ula
	ghdl -a src/ula_tb.vhd
	ghdl -e ula_tb
	ghdl -r ula_tb --wave=src/ula_tb.ghw

ports:
	ghdl -a src/ports.vhd
	ghdl -e ports
	ghdl -a src/ports_tb.vhd
	ghdl -e ports_tb
	ghdl -r ports_tb --wave=src/ports_tb.ghw

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