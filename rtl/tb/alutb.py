import cocotb
from cocotb.triggers import Timer, ReadOnly

from parameters import *

ALU_ADD = PARAMS["ALU_OPS"]["ALU_ADD"]
ALU_AND = PARAMS["ALU_OPS"]["ALU_AND"]
ALU_SUB = PARAMS["ALU_OPS"]["ALU_SUB"]
ALU_XOR = PARAMS["ALU_OPS"]["ALU_XOR"]
ALU_OR  = PARAMS["ALU_OPS"]["ALU_OR"]
ALU_SLT = PARAMS["ALU_OPS"]["ALU_SLT"]
ALU_SLTU = PARAMS["ALU_OPS"]["ALU_SLTU"]
ALU_SLL = PARAMS["ALU_OPS"]["ALU_SLL"]
ALU_SRL = PARAMS["ALU_OPS"]["ALU_SRL"]
ALU_SRA = PARAMS["ALU_OPS"]["ALU_SRA"]

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

@cocotb.test()
async def test_sll(alu):
    await check_operation(
        alu, 
        ALU_SLL, 
        0b1, 
        0x1, 
        0b10,
    )

    await check_operation(
        alu, 
        ALU_SLL, 
        0b1, 
        0x4, 
        0b10000,
    )

@cocotb.test()
async def test_srl(alu):
    await check_operation(
        alu, 
        ALU_SRL, 
        0b1000, 
        0x1, 
        0b0100,
    )

    await check_operation(
        alu, 
        ALU_SRL, 
        0b1000, 
        0x4, 
        0b0,
    )

    await check_operation(
        alu, 
        ALU_SRL, 
        0b10000, 
        0x4, 
        0b1,
    )

@cocotb.test()
async def test_sra(alu):
    await check_operation(
        alu, 
        ALU_SRA, 
        0b1000, 
        0x1, 
        0b0100,
    )

    await check_operation(
        alu, 
        ALU_SRA, 
        0b1000, 
        0x4, 
        0b0,
    )

    await check_operation(
        alu, 
        ALU_SRA, 
        0b10000, 
        0x4, 
        0b1,
    )

@cocotb.test()
async def test_slt(alu):
    await check_operation(
        alu, 
        ALU_SLT, 
        10, 
        20, 
        1,
    )

    await check_operation(
        alu, 
        ALU_SLT, 
        -5, 
        -7, 
        0,
    )


@cocotb.test()
async def test_sltu(alu):
    await check_operation(
        alu, 
        ALU_SLTU, 
        0b1000, 
        0x0001, 
        0b0,
    )

    await check_operation(
        alu, 
        ALU_SLTU, 
        0b0001, 
        0b1000, 
        0b1,
    )

@cocotb.test()
async def test_addiw(alu):
    alu.wordop.value = 1
    await check_operation(
        alu, 
        ALU_ADD, 
        0x00000000_00000010, 
        0x00000000_00000005, 
        0x00000000_00000015,
    )

    await check_operation(
        alu, 
        ALU_ADD, 
        0x00000000_7fffffff, 
        0x00000000_00000001, 
        0xffffffff80000000,
    )

@cocotb.test()
async def test_subw(alu):
    alu.wordop.value = 1
    await check_operation(
        alu, 
        ALU_SUB, 
        0x00000000_00000005, 
        0x00000000_00000010, 
        0xFFFFFFFF_FFFFFFF5
    )

@cocotb.test()
async def test_sllw(alu):
    alu.wordop.value = 1
    await check_operation(
        alu, 
        ALU_SLL, 
        0x00000000_00000001, 
        0x00000000_00000004, 
        0x00000000_00000010
    )

    await check_operation(
        alu, 
        ALU_SLL, 
        0x00000000_80000000, 
        0x00000000_00000001, 
        0x00000000_00000000
    )

@cocotb.test()
async def test_srlw(alu):
    alu.wordop.value = 1
    await check_operation(
        alu, 
        ALU_SRL, 
        0x00000000_80000000, 
        0x00000000_00000001, 
        0x00000000_40000000
    )

@cocotb.test()
async def test_sraw(alu):
    alu.wordop.value = 1
    await check_operation(
        alu, 
        ALU_SRA, 
        0x00000000_80000000, 
        0x00000000_00000001, 
        0xFFFFFFFF_C0000000
    )