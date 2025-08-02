// Immediate Generation Unit
`include "parameters.sv"

/* verilator lint_off UNUSEDSIGNAL */
module igu (
    input logic [31:0] instr,

    output logic [63:0] imm_out
);

logic [6:0] opcode;
assign opcode = instr[6:0];

always_comb begin
    case (opcode)
        `C_IM_TYPE, `C_LW_TYPE, `OP_JALR: begin
            imm_out = {{53{instr[31]}}, instr[30:20]}; //I_TYPE
        end 
        `C_SW_TYPE: begin
            imm_out = {{53{instr[31]}}, instr[30:25], instr[11:7]}; //S_TYPE
        end
        `C_B_TYPE: begin
            imm_out = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; //B_TYPE
        end
        `OP_JAL: begin
            imm_out = {{43{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; //UJ_TYPE
        end
        `OP_LUI, `OP_AUIPC: begin
            imm_out = {{32{instr[31]}}, instr[31:12], 12'b0}; // U-TYPE
        end
        default: imm_out = 64'b0;
    endcase
end

endmodule
