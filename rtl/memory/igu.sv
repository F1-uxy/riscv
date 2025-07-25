// Immediate Generation Unit

module igu (
    input logic [31:0] instr,
    input logic [2:0]  imm_type,

    output logic [63:0] imm_out
);

logic [63:0] imm;

case (imm_type)
    IMU_I: begin
        imm = {{52{instr[31]}}, instr[30:20]};
    end 
    IMU_S: begin
        imm = {{52{instr[31]}}, instr[30:25], instr[11:7]};
    end
    IMU_SB: begin
        imm = {{51{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    end
    IMU_UJ: begin
        imm = {{43{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    end
    IMU_U: begin
        imm = {instr[31:12], 12'b0};
    end
    default: imm = 64'b0;
endcase

endmodule