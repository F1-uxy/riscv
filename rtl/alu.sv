`include "rtl/parameters.sv"

module alu (
    input logic [3:0] alucontrol,
    input logic [63:0] rs1,
    input logic [63:0] rs2,

    input logic        wordop,

    output logic [63:0] result,
    output logic c_zero,
    output logic c_carry,
    output logic c_overflow
);

logic [63:0] result64;
logic [31:0] result32;

logic [63:0] sum;
logic [63:0] rs2_in;
logic sub;

assign sub = (alucontrol == `ALU_SUB);
assign rs2_in = sub ? ~rs2 : rs2;

/* Need to be updated to W spec? */
/* verilator lint_off WIDTHEXPAND */
assign {c_carry, sum} = rs1 + rs2_in + sub;

assign c_overflow = (rs1[63] == rs2_in[63]) && (sum[63] != rs1[63]);

always_comb begin
    case (alucontrol)
        `ALU_ADD: result64 = sum;
        `ALU_SUB: result64 = sum;
        `ALU_AND: result64 = rs1 & rs2;
        `ALU_OR:  result64 = rs1 | rs2;
        `ALU_XOR: result64 = rs1 ^ rs2;
        `ALU_SLL: result64 = rs1 << rs2[5:0];
        `ALU_SRL: result64 = rs1 >> rs2[5:0];
        `ALU_SRA: result64 = $signed(rs1) >>> rs2[5:0];
        `ALU_SLT: result64 = ($signed(rs1) < $signed(rs2)) ? 64'd1 : 64'd0;
        `ALU_SLTU: result64 = (rs1 < rs2);
        default: result64 = 64'd0;
    endcase
end

always_comb begin
    case (alucontrol)
        `ALU_ADD:  result32 = rs1[31:0] + rs2[31:0];
        `ALU_SUB:  result32 = rs1[31:0] - rs2[31:0];
        `ALU_SLL:  result32 = rs1[31:0] << rs2[4:0];
        `ALU_SRL:  result32 = rs1[31:0] >> rs2[4:0];
        `ALU_SRA:  result32 = $signed(rs1[31:0]) >>> rs2[4:0];
        default: result32 = 32'd0;
    endcase
end

assign result = wordop ? {{32{result32[31]}}, result32} : result64;
assign c_zero = (result == 64'd0);
    
endmodule
