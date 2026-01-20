import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock

from parameters import *

ALU_ADD = PARAMS["ALU_OPS"]["ALU_ADD"]
ALU_AND = PARAMS["ALU_OPS"]["ALU_AND"]

async def test_add(alu):
    await Timer(10, "ns")

    alu.alucontrol.value = ALU_ADD
    alu.rs1.value = 0x0005
    alu.rs2.value = 0x000A

    await Timer(10, "ns")

    assert alu.result.value == 0x000F

    await Timer(10, "ns")

    alu.alucontrol.value = ALU_ADD
    alu.rs1.value = 0xFFFFFFFFFFFFFFFF
    alu.rs2.value = 0x0000000000000001

    await Timer(10, "ns")

    assert alu.result.value == 0x0
    assert alu.c_carry.value == 1
    assert alu.c_zero.value == 1



async def test_and(alu):
    await Timer(10, "ns")

    alu.alucontrol.value = ALU_AND
    alu.rs1.value = 0xAAAA
    alu.rs2.value = 0x5555

    await Timer(10, "ns")

    assert alu.result.value == 0x0000
    assert alu.c_zero.value == 1

    alu.rs1.value = 0xAAAA
    alu.rs2.value = 0xAAAA
    
    await Timer(10, "ns")

    assert alu.result.value == 0xAAAA
    assert alu.c_zero.value == 0

@cocotb.test()
async def test_alu(alu):
    
    await test_and(alu)
    await test_add(alu)

    await Timer(10, "ns")
