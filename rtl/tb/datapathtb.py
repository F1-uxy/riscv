import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, ReadOnly, RisingEdge, ReadWrite, NextTimeStep

from parameters import *


async def start_clock(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ps").start())

async def run_clock(dut, cycles=50):
    await start_clock(dut)
    dut.reset.value = 1
    await NextTimeStep(dut.clk) 
    dut.reset.value = 0

    for _ in range(0,cycles):
        await NextTimeStep(dut.clk)

def get_signed(val, width=64):
    v = int(val)
    if v & (1 << (width - 1)):
        v -= (1 << width)
    return v

def assertRegister(dut, i, x):
    print(f"REG {i}: {dut.m_regs.regs.value[i]}")
    assert dut.m_regs.regs.value[i] == x

def check_register(dut, expected):
    for reg, val in expected.items():
        raw = (dut.m_regs.regs.value[reg])
        actual = get_signed(raw)
        print(f"REG {reg}: {actual} ; expected: {val}")
        assert actual == val, f"Register {reg} mismatch: expected {val} ; actual {actual}"
"""
@cocotb.test()
async def test_non_conflict(dut):
    from rom_results import non_conflict

    await run_clock(dut)
    check_register(dut, non_conflict)

@cocotb.test()
async def test_conflict(dut):
    from rom_results import conflict
    await run_clock(dut)
    check_register(dut, conflict)

@cocotb.test()
async def test_datapath(dut):
    from rom_results import testbench

    await start_clock(dut)
    dut.reset.value = 1
    await NextTimeStep(dut.clk) 
    dut.reset.value = 0

    for i in range(0,50):
        await NextTimeStep(dut.clk) 
    
    for i in range(0,16):
        print(f"MEM {i}: {dut.m_imem.mem.value[i]}")
        
    for i in range(0,12):
        print(f"REG {i}: {dut.m_regs.regs.value[i]}")

    check_register(dut, testbench)

@cocotb.test()
async def test_bpu(dut):
    from rom_results import bpu

    await run_clock(dut, cycles=200)
    check_register(dut, bpu)

@cocotb.test()
async def test_alu(dut):
    from rom_results import alu

    await run_clock(dut, cycles=50)
    check_register(dut, alu)
"""

"""
@cocotb.test()
async def test_loadstore(dut):
    from rom_results import loadstore

    await run_clock(dut, cycles=200)
    check_register(dut, loadstore)

@cocotb.test()
async def test_jump(dut):
    from rom_results import jump

    await run_clock(dut, cycles=200)
    check_register(dut, jump)
"""

@cocotb.test()
async def sandbox(dut):
    from rom_results import sandbox

    await run_clock(dut, cycles=50)
    check_register(dut, sandbox)
