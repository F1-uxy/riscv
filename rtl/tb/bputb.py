import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, ReadOnly, NextTimeStep, RisingEdge, ReadWrite

from parameters import *

PRED_STRONG_TAKE = PARAMS["BRANCH_PRED"]["PRED_STRONG_TAKE"]
PRED_TAKE = PARAMS["BRANCH_PRED"]["PRED_TAKE"]
PRED_NOT_TAKE = PARAMS["BRANCH_PRED"]["PRED_NOT_TAKE"]
PRED_STRONG_NOT_TAKE = PARAMS["BRANCH_PRED"]["PRED_STRONG_NOT_TAKE"]


async def start_clock(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ps").start())

async def init_dut(dut):
    await start_clock(dut)

    dut.reset.value = 1

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.reset.value = 0

async def fetch(dut, pc):
    dut.pc_fetch.value = pc
    dut.update_en.value = 0
    
    await ReadOnly()

    return int(dut.prediction.value)

async def update(dut, pc, taken):
    dut.pc_update.value = pc
    dut.update_en.value = 1
    dut.taken.value = taken

    await RisingEdge(dut.clk)
    await NextTimeStep()

    dut.update_en.value = 0

    return

async def test_entry(dut, pc, taken, expected):
    await update(dut, pc, taken)
    await NextTimeStep()
    
    pred = await fetch(dut, pc)
    assert pred == expected
    await NextTimeStep()


@cocotb.test()
async def test_bpu(dut):
    await init_dut(dut)
    pc = 0b00000000_00000000_00000000_00000000_00000000_00000000_00000000_10101000

    await test_entry(dut, pc, 0, 0) # STRONG_NOT_TAKE
    await test_entry(dut, pc, 0, 0) # STRONG_NOT_TAKE
    await test_entry(dut, pc, 1, 0) # NOT_TAKE
    await test_entry(dut, pc, 1, 1) # TAKE
    await test_entry(dut, pc, 1, 1) # STRONG_TAKE
    await test_entry(dut, pc, 0, 1) # TAKE

    pc2 = 0b00000000_00000000_00000000_00000000_00000000_00000000_00000000_11101000
    assert fetch(dut, pc2) == 0
    await test_entry(dut, pc2, 1, 1) # TAKE
    await test_entry(dut, pc2, 1, 1) # STRONG_TAKE
    assert fetch(dut, pc) == 1









