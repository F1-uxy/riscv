# Makefile

UNIT ?= datapath
VERILOG_SOURCES ?= $(PWD)/rtl/alu.sv $(PWD)/rtl/parameters.sv $(PWD)/rtl/alu_cont.sv $(PWD)/rtl/datapath.sv $(PWD)/rtl/instr_mem.sv $(PWD)/rtl/bpu.sv $(PWD)/rtl/bcu.sv $(PWD)/rtl/control_unit.sv $(PWD)/rtl/dmu.sv $(PWD)/rtl/ecu.sv $(PWD)/rtl/forwarding_unit.sv $(PWD)/rtl/hdu.sv $(PWD)/rtl/igu.sv $(PWD)/rtl/register_file.sv
TOPLEVEL ?= datapath
TEST_MODULES ?= datapathtb

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

SIM_BUILD = .sim_builds/sim_build_$(UNIT)

ALU_SOURCES = $(PWD)/rtl/alu.sv $(PWD)/rtl/parameters.sv
ALU_TM = alutb

ALU_CONT_SOURCES = $(PWD)/rtl/alu_cont.sv $(PWD)/rtl/parameters.sv
ALU_CONT_TM = alu_conttb

BPU_SOURCES = $(PWD)/rtl/bpu.sv $(PWD)/rtl/parameters.sv
BPU_TM = bputb

ifeq ($(UNIT), alu)
	VERILOG_SOURCES = $(ALU_SOURCES)
	TOPLEVEL = $(UNIT)
	TEST_MODULES = $(ALU_TM)
endif

ifeq ($(UNIT), alu_cont)
	VERILOG_SOURCES = $(ALU_CONT_SOURCES)
	TOPLEVEL = $(UNIT)
	TEST_MODULES = $(ALU_CONT_TM)
endif

ifeq ($(UNIT), bpu)
	VERILOG_SOURCES = $(BPU_SOURCES)
	TOPLEVEL = $(UNIT)
	TEST_MODULES = $(BPU_TM)
endif

VERILATOR_ARGS += -I$(PWD)/rtl
EXTRA_ARGS += --trace --trace-structs

COCOTB_TOPLEVEL = $(TOPLEVEL)

COCOTB_TEST_MODULES = $(TEST_MODULES)
export PYTHONPATH := $(PWD)/rtl/tb:$(PYTHONPATH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim