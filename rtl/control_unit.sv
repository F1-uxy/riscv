`include "parameters.sv"

module control_unit (
    input  logic [6:0] opcode,

    output logic       branch,
    output logic       reg_we,
    output logic       dmu_we,
    output logic       dmu_re,
    output logic       mtreg,
    output logic       alu_src,
    output logic       exception,
    output logic       mret,
    output logic       if_flush,
    output logic       id_flush,
    output logic       ex_flush,
    output logic [1:0] aluop
);
    
always_comb begin
    branch     = 0;
    reg_we     = 0;
    dmu_we     = 0;
    dmu_re     = 0;
    mtreg      = 0;
    alu_src    = 0;
    if_flush   = 0;
    id_flush   = 0;
    ex_flush   = 0;
    exception  = 0;
    mret       = 0;
    aluop = `ALUOP_RTYPE;

    case (opcode)
        `C_R_TYPE: begin
            reg_we     = 1;
            alu_src    = 0;
            aluop = `ALUOP_RTYPE;
        end
        `C_IM_TYPE: begin
            reg_we     = 1;
            alu_src    = 1;
            aluop = `ALUOP_RTYPE;
        end
        `C_LW_TYPE: begin
            reg_we     = 1;
            dmu_re     = 1;
            mtreg      = 1;
            alu_src    = 1;
            aluop = `ALUOP_LWSW;
        end
        `C_SW_TYPE: begin
            dmu_we     = 1;
            alu_src    = 1;
            aluop = `ALUOP_LWSW;
        end
        `C_B_TYPE: begin
            branch     = 1;
            alu_src    = 0;
            aluop = `ALUOP_BRANCH;
        end
        `OP_LUI: begin
            reg_we = 1;
            alu_src = 1;
            mtreg = 0;
        end
        `OP_AUIPC: begin
            reg_we = 1;
            alu_src = 1;
            aluop = `ALUOP_LWSW;
        end
        default: begin
            branch     = 0;
            reg_we     = 0;
            dmu_we     = 0;
            dmu_re     = 0;
            mtreg      = 0;
            alu_src    = 0;
            if_flush   = 0;
            id_flush   = 0;
            ex_flush   = 0;
            exception  = 0;
            mret       = 0;
            aluop = `ALUOP_RTYPE;
        end
    endcase
end

endmodule
