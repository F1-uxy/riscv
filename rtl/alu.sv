`include "rtl/parameters.sv"

module alu (
    input logic [3:0] alucontrol,
    input logic [31:0] rs1,
    input logic [31:0] rs2,

    output logic [31:0] result,
    output logic zero,
    output logic carry,
    output logic overflow
);

logic [31:0] sum;
logic [31:0] rs2_in;
logic sub;

//logic signed [31:0] s_rs1 = rs1;
//logic signed [31:0] s_rs2 = rs2;

assign sub = (alucontrol == `ALU_SUB);
assign rs2_in = sub ? ~rs2 : rs2;

/* verilator lint_off WIDTHEXPAND */
assign {carry, sum} = rs1 + rs2_in + sub;

assign overflow = (rs1[31] == rs2_in[31]) && (sum[31] != rs1[31]);

always_comb begin
    case (alucontrol)
        `ALU_ADD: result = sum;
        `ALU_SUB: result = sum;
        `ALU_AND: result = rs1 & rs2;
        `ALU_OR:  result = rs1 | rs2;
        default: result = 32'd0;
    endcase
end

assign zero = (result == 32'd0);
    
endmodule
