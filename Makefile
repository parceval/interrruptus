
interruptus.svf: interruptus.jed
	python3 -m util.fuseconv -d ATF1508AS $< $@

interruptus.jed: interruptus.edif
	/home/karsten/coding/atf15xx_yosys/run_fitter.sh interruptus -preassign Keep

interruptus.edif: interruptus.v
	/home/karsten/coding/atf15xx_yosys/run_yosys.sh interruptus

.PHONY: flash
flash: interruptus.svf
	openocd

interruptus_tb.vvp: interruptus_tb.v interruptus.v
	iverilog -o interruptus_tb.vvp interruptus_tb.v


interruptus_tb.vcd: interruptus_tb.vvp 
	./interruptus_tb.vvp


test: interruptus_tb.vcd	
	gtkwave interruptus_tb.vcd

.PHONY: clean
clean:
	rm -fr interruptus.jed interruptus.edif interruptus.svf

