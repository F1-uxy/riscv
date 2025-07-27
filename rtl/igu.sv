// Immediate Generation Unit
`include "rtl/parameters.sv"

/* verilator lint_off UNUSEDSIGNAL */
module igu (
    input logic [31:0] instr,
    input logic [2:0]  imm_type,

    output logic [63:0] imm_out
);

logic [63:0] imm;

always_comb begin
    case (imm_type)
        `I_TYPE: begin
            imm_out = {{53{instr[31]}}, instr[30:20]};
        end 
        `S_TYPE: begin
            imm_out = {{53{instr[31]}}, instr[30:25], instr[11:7]};
        end
        `SB_TYPE: begin
            imm_out = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        end
        `UJ_TYPE: begin
            imm_out = {{43{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        `U_TYPE: begin
            imm_out = {{32{instr[31]}}, instr[31:12], 12'b0};
        end
        default: imm_out = 64'b0;
    endcase
end

endmodule
