TESTNAME        ?=

all: build run

build:
	mkdir -p log
	mkdir -p wave
	mkdir -p coverage
	vlib work
	vmap work work
	vlog -cover bcesxf -f compile.f

run:
	vsim -l $(TESTNAME).log -coverage  -voptargs=+acc work.$(TESTNAME) -do "coverage save -onexit $(TESTNAME).ucdb; log -r /*;run -all; exit"
	mv $(TESTNAME).log ./log
	cp -rf vsim.wlf wave/$(TESTNAME).wlf
	mv $(TESTNAME).ucdb ./coverage
	ln -sf ./log/$(TESTNAME).log sim.log

clean:
	rm -rf work
	rm -rf log
	rm -rf wave
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	rm -rf coverage
	rm -rf covhtmlreport
dump:
	vsim -gui -novopt work.${TESTNAME}

cov_view:
	vsim -gui -viewcov merged.ucdb

report_cov:
	vcover merge merged.ucdb coverage/*.ucdb
	vcover report -all -file report_summary.txt merged.ucdb
	vcover report -codeAll -details -all -file report_detail.txt merged.ucdb
	vcover report -html -code bcesf -cvg -summary merged.ucdb















	
