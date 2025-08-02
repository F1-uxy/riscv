`include "library/counter.sv"

module datapath (
    input logic clk,
    input logic reset
);

    logic [31:0] instr;

    logic [4:0] rs1;
    logic [4:0] rs2;
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];

    logic [6:0] funct7;
    logic [2:0] funct3;
    assign funct7 = instr[31:25];
    assign funct3 = instr[14:12];

    logic [63:0] reg_data_in;
    logic [4:0] reg_sel;
    assign reg_sel = instr[11:7];

    logic [63:0] b_out;
    logic [63:0] a_out;


    logic [63:0] dmu_out;

    logic [63:0] imm_out;

    /*
        --- Register File ---
    */
    register_file m_regs (
        .clk(clk),
        .read_a(rs1),
        .read_b(rs2),
        .write_en(c_reg_we),
        .write_sel(reg_sel),
        .data(reg_data_in),
        
        .out_a(a_out),
        .out_b(b_out)
    );


    /*
        --- Immediate Generation Unit ---
    */
    igu m_igu (
        .instr(instr),
        
        .imm_out(imm_out)
    );

    /*
        --- Data Memory Unit ---
    */
    dmu m_dmu (
        .clk(clk),
        .write_en(c_dmu_we),
        .read_en(c_dmu_re),
        .addr(alu_out[15:0]),
        .data_in(b_out),
        
        .data_out(dmu_out)
    );

    /*
        --- ALU ---
    */
    logic [3:0] alu_op;
    logic [63:0] alu_b;
    logic [63:0] alu_out;
    logic f_zero;

    /* verilator lint_off PINMISSING */
    alu c_alu (
        .alucontrol(alu_op),
        .rs1(a_out),
        .rs2(alu_b),

        .result(alu_out),
        .c_zero(f_zero)
    );


    /*
        --- ALU Control Unit ---
    */
    alu_cont c_alu_cont (
        .funct7(funct7),
        .funct3(funct3),
        .aluop(aluop),

        .alucontrol(alu_op)
    );

    /*
        --- Program Counter ---
    */
    logic [63:0] pc_out;
    logic [63:0] pc_inc;
    counter #(.WIDTH(64)) m_pc (
        .clk(clk),
        .reset(reset),
        .inc(pc_inc),

        .out(pc_out)
    );


    /*
        --- Instruction Memory ---
    */

    instr_mem m_imem (
        .clk(clk),
        .addr(pc_out),
        .instruction(instr)
    );

    /*
        --- Control Unit ---
    */
    logic [6:0] opcode;

    logic c_branch, c_reg_we, c_dmu_we, c_dmu_re, c_mtreg, c_alu_src;
    logic [1:0] aluop;
    control_unit c_control_unit (
        .opcode(opcode),

        .branch(c_branch),
        .reg_we(c_reg_we),
        .dmu_we(c_dmu_we),
        .dmu_re(c_dmu_re),
        .mtreg(c_mtreg),
        .alu_src(c_alu_src),
        .aluop(aluop)
    );


    assign reg_data_in = c_mtreg ? dmu_out : alu_out;
    assign alu_b = c_alu_src ? imm_out : b_out;
    assign pc_inc = (c_branch && f_zero) ? (imm_out << 1) : 64'd4;
    assign opcode = instr[6:0];

endmodule
