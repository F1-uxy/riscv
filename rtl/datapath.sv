`include "library/counter.sv"

module datapath (
    input logic clk,
    input logic reset
);

    logic [31:0] instr;

    logic [4:0] rs1;
    logic [4:0] rs2;
    assign rs1 = reg_if.instr[19:15];
    assign rs2 = reg_if.instr[24:20];

    logic [6:0] funct7;
    logic [2:0] funct3;
    assign funct7 = reg_if.instr[31:25];
    assign funct3 = reg_if.instr[14:12];

    logic [63:0] reg_data_in;
    //logic [4:0] reg_sel;
    //assign reg_sel = reg_if.instr[11:7];

    logic [63:0] b_out;
    logic [63:0] a_out;


    logic [63:0] dmu_out;

    logic [63:0] imm_out;

    typedef struct packed {
        logic alu_src;
        logic [1:0] aluop;
    } rcs_ex;

    typedef struct packed {
        logic branch;
        logic mem_we;
        logic mem_re;
    } rcs_mem;

    typedef struct packed {
        logic mtreg;
        logic reg_we;
    } rcs_wb;

    typedef struct packed {
        rcs_ex ex;
        rcs_mem mem;
        rcs_wb wb;
    } rc_id_ex;

    typedef struct packed {
        rcs_mem mem;
        rcs_wb wb;
    } rc_ex_mem;

    typedef struct packed {
        rcs_wb wb;
    } rc_mem_wb;


    typedef struct packed {
        logic [31:0] instr;
        logic [63:0] pc;
    } r_if;

    typedef struct packed {
        logic [4:0] reg_sel;
        logic [63:0] data_1;
        logic [63:0] data_2;
        logic [63:0] imm;
        logic [63:0] pc;
        rc_id_ex control;
    } r_id;

    typedef struct packed {
        logic [4:0] reg_sel;
        logic [63:0] pc;
        logic [63:0] alu_res;
        logic [63:0] data_2;
        logic        f_zero;
        rc_ex_mem control;
    } r_ex;

    typedef struct packed {
        logic [4:0] reg_sel;
        logic [63:0] alu_res;
        logic [63:0] data_rd;
        rc_mem_wb control;
    } r_mem;

    /*
        --- Instruction Fetch
    */

    /*  --- Program Counter --- */
    logic [63:0] pc_out;
    logic [63:0] pc_inc;
    counter #(.WIDTH(64)) m_pc (
        .clk(clk),
        .reset(reset),
        .inc(pc_inc),

        .out(pc_out)
    );

    /* --- Instruction Memory --- */
    instr_mem m_imem (
        .clk(clk),
        .addr(pc_out),
        .instruction(instr)
    );

    r_if reg_if, next_reg_if;


    /*
        --- Instruciton Decode / Register File Read ---
    */

    /*  --- Register File --- */
    register_file m_regs (
        .clk(clk),
        .read_a(rs1),
        .read_b(rs2),
        .write_en(reg_mem.control.wb.reg_we),
        .write_sel(reg_mem.reg_sel),
        .data(reg_data_in),
        
        .out_a(a_out),
        .out_b(b_out)
    );

    /* --- Immediate Generation Unit --- */
    igu m_igu (
        .instr(instr),
        
        .imm_out(imm_out)
    );

    /* --- Control Unit --- */
    logic [6:0] opcode;

    logic c_branch, c_reg_we, c_dmu_we, c_dmu_re, c_mtreg, c_alu_src, c_pc_src;
    logic [1:0] aluop;
    control_unit c_control_unit (
        .opcode(opcode),

        .branch(c_branch),
        .reg_we(c_reg_we),
        .dmu_we(c_dmu_we),
        .dmu_re(c_dmu_re),
        .mtreg(c_mtreg),
        .alu_src(c_alu_src),
        .pc_src(c_pc_src),
        .aluop(aluop)
    );

    r_id reg_id, next_reg_id;

    /*
        --- Execute / Address Calculation ---
    */

    /* --- ALU --- */
    logic [3:0] alu_op;
    logic [63:0] alu_b;
    logic [63:0] alu_out;
    logic f_zero;
    /* verilator lint_off PINMISSING */
    alu c_alu (
        .alucontrol(alu_op),
        .rs1(reg_id.data_1),
        .rs2(alu_b),

        .result(alu_out),
        .c_zero(f_zero)
    );

    /* --- ALU Control Unit --- */
    alu_cont c_alu_cont (
        .funct7(funct7),
        .funct3(funct3),
        .aluop(reg_id.control.ex.aluop),

        .alucontrol(alu_op)
    );

    r_ex reg_ex, next_reg_ex;

    /*
        --- Memory Access ---
    */

    /* --- Data Memory Unit --- */
    dmu m_dmu (
        .clk(clk),
        .write_en(reg_ex.control.mem.mem_we),
        .read_en(reg_ex.control.mem.mem_re),
        .addr(reg_ex.alu_res[15:0]),
        .data_in(reg_ex.data_2),
        
        .data_out(dmu_out)
    );

    r_mem reg_mem, next_reg_mem;

    assign reg_data_in = reg_mem.control.wb.mtreg ? reg_mem.data_rd : reg_mem.alu_res;
    assign alu_b = reg_id.control.ex.alu_src ? reg_id.imm : reg_id.data_2;
    assign c_pc_src = (reg_ex.control.mem.branch && reg_ex.f_zero);
    assign pc_inc =  c_pc_src ? reg_ex.pc : (pc_out + 64'd4);
    assign opcode = reg_if.instr[6:0];
    

    // Combinationally prepare next stage for registers
    always_comb begin
        next_reg_if.instr = instr;
        next_reg_if.pc = pc_out;

        next_reg_id.reg_sel = instr[11:7]; // This works but it should latch from if.instr register but that delays it
        next_reg_id.data_1 = a_out;
        next_reg_id.data_2 = b_out;
        next_reg_id.imm = imm_out;
        next_reg_id.pc = reg_if.pc;
        next_reg_id.control.ex.alu_src = c_alu_src;
        next_reg_id.control.ex.aluop = aluop;
        next_reg_id.control.mem.branch = c_branch;
        next_reg_id.control.mem.mem_we = c_dmu_we;
        next_reg_id.control.mem.mem_re = c_dmu_re;
        next_reg_id.control.wb.mtreg = c_mtreg;
        next_reg_id.control.wb.reg_we = c_reg_we;

        next_reg_ex.reg_sel = reg_id.reg_sel;
        next_reg_ex.pc = (reg_id.pc + (reg_id.imm << 1));
        next_reg_ex.alu_res = alu_out;
        next_reg_ex.data_2 = reg_id.data_2;
        next_reg_ex.f_zero = f_zero;
        next_reg_ex.control.mem.branch = reg_id.control.mem.branch;
        next_reg_ex.control.mem.mem_we = reg_id.control.mem.mem_we;
        next_reg_ex.control.mem.mem_re = reg_id.control.mem.mem_re;
        next_reg_ex.control.wb.mtreg = reg_id.control.wb.mtreg;
        next_reg_ex.control.wb.reg_we = reg_id.control.wb.reg_we;

        next_reg_mem.reg_sel = reg_ex.reg_sel;
        next_reg_mem.alu_res = reg_ex.alu_res;
        next_reg_mem.data_rd = dmu_out;
        next_reg_mem.control.wb.mtreg = reg_ex.control.wb.mtreg;
        next_reg_mem.control.wb.reg_we = reg_ex.control.wb.reg_we;
    end

    always_ff @( posedge(clk) or posedge(reset)) begin
        if(reset) begin
            reg_if  <= '0;
            reg_id  <= '0;
            reg_ex  <= '0;
            reg_mem <= '0;
        end else begin
            reg_if <= next_reg_if;
            reg_id <= next_reg_id;
            reg_ex <= next_reg_ex;
            reg_mem <= next_reg_mem;
        end
    end

endmodule
