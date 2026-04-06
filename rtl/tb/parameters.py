PARAMS = {
    "ALU_OPS": {
        "ALU_AND":     0b0000,
        "ALU_OR":      0b0001,
        "ALU_XOR":     0b0010,
        "ALU_ADD":     0b0011,
        "ALU_SUB":     0b0100,
        "ALU_SLT":     0b0101,
        "ALU_SLTU":    0b0110,
        "ALU_SLL":     0b0111,
        "ALU_SRL":     0b1000,
        "ALU_SRA":     0b1001,
        "ALU_INVALID": None,
    },
    "ALUOP": {
        "ALUOP_LWSW":   0b00,
        "ALUOP_BRANCH": 0b01,
        "ALUOP_RTYPE":  0b10,
    },
    "IMU": {
        "R_TYPE":  0b000,
        "I_TYPE":  0b001,
        "S_TYPE":  0b010,
        "SB_TYPE": 0b011,
        "UJ_TYPE": 0b100,
        "U_TYPE":  0b101,
    },
    "CTRL": {
        "C_R_TYPE":  0b0110011,
        "C_IM_TYPE": 0b0010011,
        "C_LW_TYPE": 0b0000011,
        "C_SW_TYPE": 0b0100011,
        "C_B_TYPE":  0b1100011,
        "OP_LUI":    0b0110111,
        "OP_AUIPC":  0b0010111,
        "OP_JAL":    0b1101111,
        "OP_JALR":   0b1100111,
    },
    "BRANCH_PRED": {
        "PRED_STRONG_TAKE":     0b11,
        "PRED_TAKE":            0b10,
        "PRED_NOT_TAKE":        0b01,
        "PRED_STRONG_NOT_TAKE": 0b00,
    },
    "EXCEPTION": {
        "EXCEPTION_ADDR": 0x00000000_1C090000,
    }
}