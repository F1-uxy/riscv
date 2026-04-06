`ifndef PARAMETERS_SV
`define PARAMETERS_SV

// ALU Operation Codes
`define ALU_AND      4'b0000
`define ALU_OR       4'b0001
`define ALU_XOR      4'b0010
`define ALU_ADD      4'b0011
`define ALU_SUB      4'b0100
`define ALU_SLT      4'b0101
`define ALU_SLTU     4'b0110
`define ALU_SLL      4'b0111
`define ALU_SRL      4'b1000
`define ALU_SRA      4'b1001
`define ALU_INVALID  4'bxxxx

// ALUOP signals
`define ALUOP_LWSW   2'b00   // load/store (use ADD)
`define ALUOP_BRANCH 2'b01   // beq (use SUB)
`define ALUOP_RTYPE  2'b10   // R-type (use funct3/funct7)

// IMU signals
`define R_TYPE  3'b000
`define I_TYPE  3'b001
`define S_TYPE  3'b010
`define SB_TYPE 3'b011
`define UJ_TYPE 3'b100
`define U_TYPE  3'b101

// Control Unit Opcode Types
`define C_R_TYPE   7'b0110011
`define C_IM_TYPE  7'b0010011
`define C_LW_TYPE  7'b0000011
`define C_SW_TYPE  7'b0100011
`define C_B_TYPE   7'b1100011

`define OP_LUI     7'b0110111
`define OP_AUIPC   7'b0010111
`define OP_JAL     7'b1101111
`define OP_JALR    7'b1100111

// Branch Prediction
`define PRED_STRONG_TAKE        2'b11
`define PRED_TAKE               2'b10
`define PRED_NOT_TAKE           2'b01
`define PRED_STRONG_NOT_TAKE    2'b00

// Exception/Interrupts:
`define EXCEPTION_ADDR 64'h0000_0000_1C09_0000

`endif


