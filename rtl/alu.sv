`include "rtl/parameters.svh"

module alu (
    input logic [3:0] alucontrol,
    input logic [31:0] rs1,
    input logic [31:0] rs2,

    output logic [31:0] result,
    output logic zero
);

logic [31:0] sum;
logic [31:0] rs1_in;
logic sub;

logic signed [31:0] s_rs1 = rs1;
logic signed [31:0] s_rs2 = rs2;

assign sub = (alucontrol == ALU_SUB);
assign rs2_in = sub ? ~rs2 : rs2;
assign sum = rs1 + rs2_in + sub;

always_comb begin
    case (alucontrol)
        ALU_ADD: result = sum;
        ALU_SUB: result = sum;
        ALU_AND: result = rs1 & rs2;
        ALU_OR:  result = rs1 | rs2;
        default: alu_result = 32'd0;
    endcase
end

assign zero = (result == 32'd0);
    
endmodule