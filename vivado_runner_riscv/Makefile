#------------------------------------------------------------------------------
#  vivado_design_space_explorer_template
#  Makefile for iterative compilation for AMD / Xilinx Vivado
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------
#
#
# INFO ------------------------------------------------------------------------
# - This is a top-level Makefile
# - It makes a bunch of Vivado project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate vivado project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


DUT_START = 1
DUT_STOP  = 10

PART_START = 1
PART_STOP  = 11

PARTS = \
xc7s100fgga676-2 \
xc7a200tffv1156-2 \
xc7k325tffv900-2 \
xc7vx330tffv1761-2 \
xcku040-ffva1156-2-i \
xcvu065-ffvc1517-2-i \
xcsu35p-sbvb625-2-i \
xcau25p-sfvb784-2-i \
xcku9p-ffve900-2-i \
xcvu3p-ffvc1517-2-i \
xcvm1102-sfva784-2MP-i-S

VAR1 = $(shell seq $(DUT_START) $(DUT_STOP))
VAR2 = $(shell seq $(PART_START) $(PART_STOP))

JOBS = $(foreach v1, $(VAR1), $(foreach v2, $(VAR2), $(v1)_$(v2)))


.PHONY: all report clean


all: report
	echo '$@ success'

${JOBS}: %:
	V1=$$(echo $* | cut -d'_' -f1); \
	V2=$$(echo $* | cut -d'_' -f2); \
	PART=$$(echo "$(PARTS)" | awk -v idx="$$V2" '{print $$idx}'); \
	echo "==> Запуск job_$*: V1 = $$V1, V2 = $$V2, PART = $$PART"; \
	mkdir -p ./$*; \
	cp -r ./base/* ./$*; \
	cp "../test_suite/test$$V1.sv" ./$*/src/test.sv; \
	$(MAKE) -C ./$* PART=$$PART all

report: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	echo 'job, fmax' >> fmax.csv; \
	export BC_LINE_LENGTH=0; \
	for job in $(JOBS); do \
		echo $$job | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		(cat ./$$job/test.runs/impl_1/main_timing_summary_routed.rpt | \
			grep -A6 'Design Timing Summary' | tail -n1 | gawk {'print $$1'} | \
			xargs echo -n '1000/(1-'; echo ')') | bc | xargs echo -n >> fmax.csv; \
		echo >> fmax.csv; \
	done; \
	echo '# UTIL summary report for iterative compilation' > util.csv; \
	echo 'job, lut, ff, bram, dsp' >> util.csv; \
	export BC_LINE_LENGTH=0; \
	for job in $(JOBS); do \
		echo $$job | xargs echo -n >> util.csv; \
		echo -n ', ' >> util.csv; \
		cat ./$$job/test.runs/impl_1/main_utilization_placed.rpt | \
			grep 'LUTs' | head -n1 | gawk {'print $$5'} | xargs echo -n >> util.csv; \
		echo -n ', ' >> util.csv; \
		cat ./$$job/test.runs/impl_1/main_utilization_placed.rpt | \
			grep 'Registers' | head -n2 | tail -n1 | gawk {'print $$5'} | xargs echo -n >> util.csv; \
		echo -n ', ' >> util.csv; \
		cat ./$$job/test.runs/impl_1/main_utilization_placed.rpt | \
			grep 'Block RAM Tile' | head -n1 | gawk {'print $$6'} | xargs echo -n >> util.csv; \
		echo -n ', ' >> util.csv; \
		cat ./$$job/test.runs/impl_1/main_utilization_placed.rpt | \
			grep 'DSPs' | head -n1 | gawk {'print $$4'} | xargs echo -n >> util.csv; \
		echo >> util.csv; \
	done

clean:
	for job in $(JOBS); do \
		rm -rfv $$job; \
	done \
	rm -rfv fmax.csv; \
	rm -rfv util.csv

