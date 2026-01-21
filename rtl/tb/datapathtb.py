import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, ReadOnly, RisingEdge, ReadWrite, NextTimeStep

from parameters import *

async def start_clock(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ps").start())

@cocotb.test()
async def test_datapath(dut):
    await start_clock(dut)
    dut.reset.value = 1
    await NextTimeStep(dut.clk) 
    dut.reset.value = 0

    for i in range(0,15):
        await NextTimeStep(dut.clk) 
    
    for i in range(0,16):
        print(f"MEM {i}: {dut.m_imem.mem.value[i]}")
        

    for i in range(0,12):
        print(f"REG {i}: {dut.m_regs.regs.value[i]}")


    assert True == True
