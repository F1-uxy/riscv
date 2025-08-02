// alu.h - ALU Operation Codes and ALUOp signals for RISC-V

#ifndef ALU_H
#define ALU_H

// ALU Operation Codes (4-bit)
#define ALU_ADD      0b0011  // Addition
#define ALU_SUB      0b0110  // Subtraction
#define ALU_AND      0b0000  // Bitwise AND
#define ALU_OR       0b0001  // Bitwise OR
#define ALU_XOR      0b0010  // Bitwise XOR

#define ALU_INVALID  0b1111  // Invalid operation (since 'xxxx' isn't valid in C)

// ALUOp Signals (2-bit)
#define ALUOP_LWSW   0b00    // Load/Store (use ADD)
#define ALUOP_BRANCH 0b01    // Branch (use SUB)
#define ALUOP_RTYPE  0b10    // R-type (decode funct3/funct7)

// IMU signals (3-bit values)
#define R_TYPE   0b000  // 0
#define I_TYPE   0b001  // 1
#define S_TYPE   0b010  // 2
#define SB_TYPE  0b011  // 3
#define UJ_TYPE  0b100  // 4
#define U_TYPE   0b101  // 5

// Control Unit Opcode Types (7-bit values)
#define C_R_TYPE   0b0110011  // 0x33
#define C_IM_TYPE  0b0010011  // 0x13
#define C_LW_TYPE  0b0000011  // 0x03
#define C_SW_TYPE  0b0100011  // 0x23
#define C_B_TYPE   0b1100011  // 0x63

#define OP_LUI     0b0110111  // 0x37
#define OP_AUIPC   0b0010111  // 0x17
#define OP_JAL     0b1101111  // 0x6F
#define OP_JALR    0b1100111  // 0x67

#endif // ALU_H
