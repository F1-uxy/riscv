import cocotb
from cocotb.triggers import Timer, ReadOnly

from parameters import *

ALUOP_RTYPE  = PARAMS["ALUOP"]["ALUOP_RTYPE"]
ALUOP_BRANCH = PARAMS["ALUOP"]["ALUOP_BRANCH"]
ALUOP_LWSW   = PARAMS["ALUOP"]["ALUOP_LWSW"]

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

async def request_type(dut, op, funct7, funct3, alucontrol, name=""):
    dut.aluop.value = op
    dut.funct7.value = funct7
    dut.funct3.value = funct3

    await ReadOnly()

    actual = dut.alucontrol.value
    assert actual == alucontrol, (
        f"{name} failed: "
        f"aluop={op:#x}, funct7={funct7:#x}, funct3={funct3:#x}, "
        f"expected alucontrol={alucontrol:#x}, got={alucontrol:#x}"
    )
    
    await Timer(10, "ps")


@cocotb.test()
async def test_rtype(alu_cont):
    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0,
        0,
        ALU_ADD,
        name="R-type ADD"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0100000,
        0b0,
        ALU_SUB,
        name="R-type SUB"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b111,
        ALU_AND,
        name="R-type AND"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b110,
        ALU_OR,
        name="R-type OR"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b100,
        ALU_XOR,
        name="R-type XOR"
    )
    
    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b001,
        ALU_SLL,
        name="R-type SLL"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b010,
        ALU_SLT,
        name="R-type SLT"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b011,
        ALU_SLTU,
        name="R-type SLTU"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0100000,
        0b101,
        ALU_SRA,
        name="R-type SRA"
    )

    await request_type(
        alu_cont,
        ALUOP_RTYPE,
        0b0,
        0b101,
        ALU_SRL,
        name="R-type SRL"
    )



@cocotb.test()
async def test_lwsw(alu_cont):
    await request_type(
        alu_cont,
        ALUOP_LWSW,
        0b0,
        0b0,
        ALU_ADD
    )


@cocotb.test()
async def test_branch(alu_cont):
    await request_type(
        alu_cont,
        ALUOP_BRANCH,
        0b0,
        0b0,
        ALU_SUB
    )