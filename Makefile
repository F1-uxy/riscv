# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/rtl/alu.sv $(PWD)/rtl/parameters.sv
VERILATOR_ARGS += -I$(PWD)/rtl
EXTRA_ARGS += --trace --trace-structs

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = alu

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = alutb
export PYTHONPATH := $(PWD)/rtl/tb:$(PYTHONPATH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim