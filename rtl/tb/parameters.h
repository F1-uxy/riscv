// alu.h - ALU Operation Codes and ALUOp signals for RISC-V

#ifndef ALU_H
#define ALU_H

// ALU Operation Codes (4-bit)
#define ALU_ADD      0b0010  // Addition
#define ALU_SUB      0b0110  // Subtraction
#define ALU_AND      0b0000  // Bitwise AND
#define ALU_OR       0b0001  // Bitwise OR
#define ALU_INVALID  0b1111  // Invalid operation (since 'xxxx' isn't valid in C)

// ALUOp Signals (2-bit)
#define ALUOP_LWSW   0b00    // Load/Store (use ADD)
#define ALUOP_BRANCH 0b01    // Branch (use SUB)
#define ALUOP_RTYPE  0b10    // R-type (decode funct3/funct7)

#endif // ALU_H
