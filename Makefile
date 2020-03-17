ula:
	ghdl -a src/ula.vhd
	ghdl -e ula
	ghdl -a src/ula_tb.vhd
	ghdl -e ula_tb
	ghdl -r ula_tb --wave=src/ula_tb.ghw
	# gtkwave src/ula_tb.ghw

ports:
	ghdl -a src/ports.vhd
	ghdl -e ports
	ghdl -a src/ports_tb.vhd
	ghdl -e ports_tb
	ghdl -r ports_tb --wave=src/ports_tb.ghw
	# gtkwave src/ports_tb.ghw

reg16bits:
	ghdl -a src/reg16bits.vhd
	ghdl -e reg16bits
	ghdl -a src/reg16bits_tb.vhd 
	ghdl -e reg16bits_tb 
	ghdl -r reg16bits_tb --stop-time=3000ns --wave=src/reg16bits_tb.ghw 