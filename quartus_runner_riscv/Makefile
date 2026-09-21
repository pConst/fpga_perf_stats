#------------------------------------------------------------------------------
#  quartus_design_space_explorer_template
#  Makefile for iterative compilation for Intel / Altera Quartus
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------
#
#
# INFO ------------------------------------------------------------------------
# - This is a top-level Makefile
# - It makes a bunch of Quartus project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate quartus project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


DUT_START = 1
DUT_STOP  = 1

PART_START = 1
PART_STOP  = 7

FAMILIES = \
MAX_10 \
Cyclone_IV_E \
Cyclone_V \
Cyclone_10_LP \
Arria_V \
Arria_10 \
Stratix_V 

DEVICES = \
10M50DDF672I7G \
EP4CE115F29I7 \
5CEFA7F31I7 \
10CL120YF780I7G \
5AGXMB3G4F40I5 \
10AX032H2F35I2SG \
5SGXMB5R2F43I2

VAR1 = $(shell seq $(DUT_START) $(DUT_STOP))
VAR2 = $(shell seq $(PART_START) $(PART_STOP))

JOBS = $(foreach v1, $(VAR1), $(foreach v2, $(VAR2), $(v1)_$(v2)))


.PHONY: all report clean


all: report
	echo '$@ success'

${JOBS}: %:
	V1=$$(echo $* | cut -d'_' -f1); \
	V2=$$(echo $* | cut -d'_' -f2); \
	FAMILY=$$(echo "$(FAMILIES)" | awk -v idx="$$V2" '{print $$idx}' | awk '{ gsub(/_/, " "); print }'); \
	DEVICE=$$(echo  "$(DEVICES)" | awk -v idx="$$V2" '{print $$idx}' | awk '{ gsub(/_/, " "); print }'); \
	echo "==> Запуск job_$*: V1 = $$V1, V2 = $$V2, FAMILY=$$FAMILY, DEVICE = $$DEVICE"; \
	mkdir -p ./$*; \
	cp -r ./base/* ./$*; \
	echo "set_global_assignment -name FAMILY \"$$FAMILY\"" > ./$*/family_device.qsf; \
	echo "set_global_assignment -name DEVICE \"$$DEVICE\"" >> ./$*/family_device.qsf; \
	$(MAKE) -C ./$* stap

report: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	echo 'job, fmax, restricted_fmax' >> fmax.csv; \
	export BC_LINE_LENGTH=0; \
	for job in $(JOBS); do \
		echo $$job | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$job/OUTPUT/test.sta.rpt | \
		grep -A2 'Restricted Fmax' | \
		tail -n1 | gawk {'print $$2'} | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$job//OUTPUT/test.sta.rpt | \
		grep -A2 'Restricted Fmax' | \
		tail -n1 | gawk {'print $$5'} | xargs echo -n >> fmax.csv; \
		echo >> fmax.csv; \
	done

clean:
	for job in $(JOBS); do \
		rm -rfv $$job; \
	done \
	rm -rfv fmax.csv; \
	rm -rfv util.csv

