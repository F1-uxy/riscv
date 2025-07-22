`include "rtl/parameters.svh"

module alu_cont (
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    input logic [1:0] aluop,

    output logic [3:0] alucontrol
);

always_comb begin
    case (aluop)
        `ALUOP_LWSW: begin
            alucontrol = `ALU_ADD; // ADD
        end
        `ALUOP_BRANCH: begin
            alucontrol = `ALU_SUB; // SUB
        end
        `ALUOP_RTYPE: begin
            case ({funct7, funct3})
                {7'b0000000, 3'b000}: 
                    alucontrol = `ALU_ADD; // ADD
                {7'b0100000, 3'b000}:
                    alucontrol = `ALU_SUB; // SUB
                {7'b0000000, 3'b111}:
                    alucontrol = `ALU_AND; // AND
                {7'b0000000, 3'b110}:
                    alucontrol = `ALU_OR; // OR
                default: alucontrol = `ALU_INVALID; // INVALID
            endcase
        end
        default: alucontrol = `ALU_INVALID;
    endcase
end
    
endmodule