import cocotb
from cocotb.triggers import Timer, ReadOnly

from parameters import *

ALU_ADD = PARAMS["ALU_OPS"]["ALU_ADD"]
ALU_AND = PARAMS["ALU_OPS"]["ALU_AND"]
ALU_SUB = PARAMS["ALU_OPS"]["ALU_SUB"]
ALU_XOR = PARAMS["ALU_OPS"]["ALU_XOR"]
ALU_OR  = PARAMS["ALU_OPS"]["ALU_OR"]

async def check_operation(dut, op, a, b, result, carry=None, zero=None):
    dut.alucontrol.value = op
    dut.rs1.value = a
    dut.rs2.value = b

    await ReadOnly()

    assert dut.result.value == result
    if carry is not None:
        assert dut.c_carry.value == carry
    if zero is not None:
        assert dut.c_zero.value == zero
    
    await Timer(10, "ps")


@cocotb.test()
async def test_add(alu):
    await check_operation(
        alu, 
        ALU_ADD, 
        0x5, 
        0xA, 
        0xF
    )

    await check_operation(
        alu,
        ALU_ADD,
        0xFFFFFFFFFFFFFFFF, 
        0x1,
        0x0, 
        carry=1, 
        zero=1
    )


@cocotb.test()
async def test_and(alu):
    await check_operation(
        alu, 
        ALU_AND, 
        0xAAAA, 
        0x5555, 
        0x0000,
        zero=1
    )

    await check_operation(
        alu,
        ALU_AND,
        0xAAAA, 
        0xAAAA,
        0xAAAA, 
        zero=0
    )

@cocotb.test()
async def test_sub(alu):
    await check_operation(
        alu, 
        ALU_SUB, 
        0x000A, 
        0x0005, 
        0x0005,
    )

    await check_operation(
        alu,
        ALU_SUB,
        0x0005, 
        0x000A,
        0xFFFFFFFFFFFFFFFB, 
    )


@cocotb.test()
async def test_xor(alu):
    await check_operation(
        alu, 
        ALU_XOR, 
        0x000A, 
        0x00A0, 
        0x00AA,
    )

    await check_operation(
        alu,
        ALU_XOR,
        0x1010, 
        0x1010,
        0x0000,
        zero=1 
    )


@cocotb.test()
async def test_or(alu):
    await check_operation(
        alu, 
        ALU_OR, 
        0x1010, 
        0x1010, 
        0x1010,
    )

    await check_operation(
        alu,
        ALU_OR,
        0x000A, 
        0x00A0,
        0x00AA,
    )
