// ALU Operation Codes
`define ALU_ADD      4'b0010
`define ALU_SUB      4'b0110
`define ALU_AND      4'b0000
`define ALU_OR       4'b0001
`define ALU_INVALID  4'bxxxx

// ALUOP signals
`define ALUOP_LWSW   2'b00   // load/store (use ADD)
`define ALUOP_BRANCH 2'b01   // beq (use SUB)
`define ALUOP_RTYPE  2'b10   // R-type (use funct3/funct7)

// IMU signals
`define IMU_I  3'b000
`define IMU_S  3'b001
`define IMU_SB 3'b010
`define IMU_UJ 3'b011
`define IMU_U  3'b100


