#------------------------------------------------------------------------------
#  quartus_design_space_explorer_template
#  Makefile for iterative compilation for Intel / Altera Quartus
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------
#
#
# INFO ------------------------------------------------------------------------
#
# - This is a top-level Makefile
# - It makes a bunch of Quartus project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate quartus project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


DUT_START = 32
DUT_STOP  = 33

PART_START = 1
PART_STOP  = 8

PARTS = xc7s100fgga676-2 \
	xc7a200tffv1156-2 \
	xc7k325tffv900-2 \
	xc7vx330tffv1761-2 \
	xcku040-ffva1156-2-i \
	xcvu065-ffvc1517-2-i \
	xcku9p-ffve900-2-i \
	xcvu3p-ffvc1517-2-i

VAR1 = $(shell seq $(DUT_START) $(DUT_STOP))
VAR2 = $(shell seq $(PART_START) $(PART_STOP))

JOBS = $(foreach v1, $(VAR1), $(foreach v2, $(VAR2), job_$(v1)_$(v2)))


.PHONY: all report clean


all: fmax
	echo '$@ success'

${JOBS}: job_%:
	V1=$$(echo $* | cut -d'_' -f1); \
	V2=$$(echo $* | cut -d'_' -f2); \
	PART=$$(echo "$(PARTS)" | awk -v idx="$$V2" '{print $$idx}'); \
	echo "==> Запуск job_$*: V1 = $$V1, V2 = $$V2, PART = $$PART"; \
	mkdir -p ./$*; \
	cp -r ./base/* ./$*; \
	cp "../test_suite/dut$$V2.sv" ./$*; \
	$(MAKE) -C ./$* PART=$$PART stap

fmax: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	echo 'var, clk1, clk2' >> fmax.csv; \
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		echo $$v | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$v/OUTPUT/test.sta.rpt | \
		grep -A3 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
		tail -n1 | gawk {'print $$5'} | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$v/OUTPUT/test.sta.rpt | \
		grep -A2 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
		tail -n1 | gawk {'print $$5'} | xargs echo -n >> fmax.csv; \
		echo >> fmax.csv; \
		v=$$((v+1)); \
	done

report: fmax.csv
	cat fmax.csv

clean:
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		rm -rfv $$v; \
		rm -rfv fmax.csv; \
		v=$$((v+1)); \
	done

