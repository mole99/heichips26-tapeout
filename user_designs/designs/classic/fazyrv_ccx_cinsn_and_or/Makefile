# Adjust sources
RTL = fazyrv_ccx_cinsn_and_or.sv
TOP = fazyrv_ccx_cinsn_and_or

# Include base Makefile
include ../../../makefile.include

# Smoke test
TB      = fazyrv_ccx_cinsn_and_or_tb.sv
TB_TOP  = fazyrv_ccx_cinsn_and_or_tb

IVFLAGS  ?= -g2012 -Wall -s $(TB_TOP)
IVERILOG ?= iverilog
VVP      ?= vvp

SIM  := sim.vvp

simulate: $(TB) $(RTL)
	$(IVERILOG) $(IVFLAGS) -o $(SIM) $(TB) $(RTL)
	$(VVP) $(SIM)
