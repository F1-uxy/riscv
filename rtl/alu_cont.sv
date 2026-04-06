`include "rtl/parameters.sv"

module alu_cont (
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    input  logic [1:0] aluop,
    output logic [3:0] alucontrol
);

always_comb begin
    case (aluop)

        `ALUOP_LWSW: begin
            alucontrol = `ALU_ADD; // Effective address: base + offset
        end

        `ALUOP_BRANCH: begin
            alucontrol = `ALU_SUB; // Comparator
        end

        `ALUOP_RTYPE: begin
            case (funct3)
                3'b000: alucontrol = (funct7 == 7'b0100000) ? `ALU_SUB : `ALU_ADD;
                3'b001: alucontrol = `ALU_SLL;
                3'b010: alucontrol = `ALU_SLT;
                3'b011: alucontrol = `ALU_SLTU;
                3'b100: alucontrol = `ALU_XOR;
                3'b101: alucontrol = (funct7 == 7'b0100000) ? `ALU_SRA : `ALU_SRL;
                3'b110: alucontrol = `ALU_OR;
                3'b111: alucontrol = `ALU_AND;
                default: alucontrol = `ALU_ADD;
            endcase
        end

        default: alucontrol = `ALU_INVALID;
    endcase
end

endmodule
