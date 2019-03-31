# Used programs
# vhd2vl (VHDL to Verilog translator) http://doolittle.icarus.com/~larry/vhd2vl/
# apio (tool chain for fpga) https://apiodoc.readthedocs.io/en/stable/source/installation.html
# gtkwave (wave viewer) https://sourceforge.net/projects/gtkwave/
# ghdl (vhdl simulator) http://ghdl.free.fr/

BOARD := alhambra-ii

VHD_FILES := $(shell find . -maxdepth 1 -type f ! -name "*_tb.vhd" -name "*.vhd" )
VHD_FILES_NOEXT := $(notdir $(basename $(VHD_FILES)))

NC := \033[0m
BICyan := \033[1;96m
BIGreen := \033[1;92m

# Init project
# make init
init:
	apio init --board=$(BOARD)

# Simulate with testbench entity tb for 10 ms
# make sim top=tb time=10ms
sim:
	@echo -e "$(BICyan)\n Checking syntaxis... $(NC)"
	@ghdl -s *.vhd
	@echo -e "$(BIGreen) Syntaxis is correct!\n $(NC)"
	@echo -e "$(BICyan) Checking architecture... $(NC)"
	@ghdl -a *.vhd
	@echo -e "$(BIGreen) Architecture is correct!\n $(NC)"
	@echo -e "$(BICyan) Synthesising... $(NC)"
	@ghdl -e $(top)
	@echo -e "$(BIGreen) Synthesis done!\n $(NC)"
	@echo -e "$(BICyan) Simulating... $(NC)"
	@ghdl -r $(top) --wave=output.ghw --stop-time=$(time)
	@echo -e "$(BIGreen) Simulation done!\n $(NC)"
	@echo -e "$(BICyan) Opening gtkwave... $(NC)"
	@gtkwave output.ghw
	@rm output.ghw
	@echo -e "$(BIGreen) Simulation file cleaned\n $(NC)"

# Build target, files ending on _tb are not built
# make build
build:
	@for file in $(VHD_FILES_NOEXT) ; do \
		echo -e "$(BICyan)\n Translating $$file $(NC)"; \
		vhd2vl "$$file.vhd" > "$$file.v";\
	done
	@echo -e "$(BICyan)\n Building... $(NC)"
	@apio build --verbose-arachne
	@rm *.v

# Build target and upload
# make upload
upload:	build
	@echo -e "$(BICyan) \n Uploading... $(NC)"
	@apio upload

# Clean bitstream and synthesis
# make clean
clean:
	@echo -e "$(BICyan) \n Cleaning... $(NC)"
	@rm -f *.asc
	@rm -f *.bin
	@rm -f *.blif
	@rm -f *.cf
