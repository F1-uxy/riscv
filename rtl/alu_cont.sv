`include "rtl/parameters.sv"

module alu_cont (
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    input  logic [2:0] instr_type,
    output logic [3:0] alucontrol
);

always_comb begin
    case (instr_type)

        `I_TYPE: begin
            case (funct3)
                3'b000: alucontrol = `ALU_ADD; // ADDI
                3'b111: alucontrol = `ALU_AND; // ANDI
                3'b110: alucontrol = `ALU_OR;  // ORI
                default: alucontrol = `ALU_INVALID;
            endcase
        end

        `S_TYPE: begin
            alucontrol = `ALU_ADD; // Effective address: base + offset
        end

        `SB_TYPE: begin
            alucontrol = `ALU_SUB; // BEQ/BNE/BLT — usually use subtraction
        end

        `U_TYPE: begin
            alucontrol = `ALU_INVALID;
        end

        `UJ_TYPE: begin
            alucontrol = `ALU_INVALID;
        end

        `R_TYPE: begin
            case ({funct7, funct3})
                {7'b0000000, 3'b000}: alucontrol = `ALU_ADD; // ADD
                {7'b0100000, 3'b000}: alucontrol = `ALU_SUB; // SUB
                {7'b0000000, 3'b111}: alucontrol = `ALU_AND; // AND
                {7'b0000000, 3'b110}: alucontrol = `ALU_OR;  // OR
                default: alucontrol = `ALU_INVALID;
            endcase
        end

        default: alucontrol = `ALU_INVALID;

    endcase
end

endmodule
