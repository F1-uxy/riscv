`include "rtl/parameters.sv"

module control_unit (
    input  logic [6:0] opcode,

    output logic       branch,
    output logic       reg_we,
    output logic       dmu_we,
    output logic       dmu_re,
    output logic       mtreg,
    output logic       alu_src,
    output logic       pc_src,
    output logic [2:0] instr_type
);
    
always_comb begin
    branch     = 0;
    reg_we     = 0;
    dmu_we     = 0;
    dmu_re     = 0;
    mtreg      = 0;
    alu_src    = 0;
    pc_src     = 0;
    instr_type = `R_TYPE;

    case (opcode)
        `C_R_TYPE: begin
            reg_we     = 1;
            alu_src    = 0;
            instr_type = `R_TYPE;
        end
        `C_IM_TYPE: begin
            reg_we     = 1;
            alu_src    = 1;
            instr_type = `I_TYPE;
        end
        `C_LW_TYPE: begin
            reg_we     = 1;
            dmu_re     = 1;
            mtreg      = 1;
            alu_src    = 1;
            instr_type = `I_TYPE;
        end
        `C_SW_TYPE: begin
            dmu_we     = 1;
            alu_src    = 1;
            instr_type = `S_TYPE;
        end
        `C_BEQ_TYPE: begin
            branch     = 1;
            alu_src    = 0;
            instr_type = `SB_TYPE;
        end
        default: begin
            branch     = 0;
            reg_we     = 0;
            dmu_we     = 0;
            dmu_re     = 0;
            mtreg      = 0;
            alu_src    = 0;
            pc_src     = 0;
            instr_type = `R_TYPE;
        end
    endcase
end

endmodule
