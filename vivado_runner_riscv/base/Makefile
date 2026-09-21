#------------------------------------------------------------------------------
#  base Makefile for Vivado project
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

PROJ = test

# expecting this variable to be overriden
PART = xc7s100fgga676-2

SRCS = scr1/scr1_ahb.svh \
scr1/scr1_arch_description.svh \
scr1/scr1_arch_types.svh \
scr1/scr1_cg.sv \
scr1/scr1_clk_ctrl.sv \
scr1/scr1_core_top.sv \
scr1/scr1_csr.svh \
scr1/scr1_dmi.sv \
scr1/scr1_dm.sv \
scr1/scr1_dm.svh \
scr1/scr1_dp_memory.sv \
scr1/scr1_hdu.svh \
scr1/scr1_ipic.sv \
scr1/scr1_ipic.svh \
scr1/scr1_mem_axi.sv \
scr1/scr1_memif.svh \
scr1/scr1_pipe_csr.sv \
scr1/scr1_pipe_exu.sv \
scr1/scr1_pipe_hdu.sv \
scr1/scr1_pipe_ialu.sv \
scr1/scr1_pipe_idu.sv \
scr1/scr1_pipe_ifu.sv \
scr1/scr1_pipe_lsu.sv \
scr1/scr1_pipe_mprf.sv \
scr1/scr1_pipe_tdu.sv \
scr1/scr1_pipe_top.sv \
scr1/scr1_reset_cells.sv \
scr1/scr1_riscv_isa_decoding.svh \
scr1/scr1_scu.sv \
scr1/scr1_scu.svh \
scr1/scr1_search_ms1.svh \
scr1/scr1_tapc_shift_reg.sv \
scr1/scr1_tapc.sv \
scr1/scr1_tapc.svh \
scr1/scr1_tapc_synchronizer.sv \
scr1/scr1_tdu.svh \
src/test.sv \
src/main.sv

XDCS = src/timing.xdc

SCRIPTS = scripts/allow_undefined_ports.tcl

#------------------------------------------------------------------------------

.PHONY: all info setup compile clean

all: setup compile

info:
	echo -e \\n '    Project name: ' $(PROJ) \
	        \\n '    Part:         ' $(PART) \
			\\n '    Sources:      ' $(SRCS) \
			\\n '    Constraints:  ' $(XDCS) \
			\\n '    Scripts:      ' $(SCRIPTS)

setup: .setup.done

.setup.done: $(SRCS) $(SCRIPTS)
	# passing args as files
	echo $(PROJ) > .proj
	echo $(PART) > .part
	echo $(SRCS) | tr -s " " "\012" > .srcs
	echo $(XDCS) | tr -s " " "\012" > .xdcs
	echo $(SCRIPTS) | tr -s " " "\012" > .scripts
	# processing
	vivado -mode batch -source scripts/set_prj_vivado.tcl
	# cleaning
	rm -f .proj
	rm -f .part
	rm -f .srcs
	rm -f .xdcs
	rm -f .scripts

compile: .compile.done

.compile.done: .setup.done
	vivado -mode batch -source scripts/compile_vivado.tcl

clean:
	$(shell ./clean_vivado.sh )
	rm -f $(PROJ).xpr
	rm -f .part
	rm -f .srcs
	rm -f .xdcs
	rm -f .scripts

