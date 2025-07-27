module memory (
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
logic [5:0] reg_sel;
assign reg_sel = instr[11:7];

logic [63:0] b_out;
logic [63:0] a_out;

logic [63:0] alu_b;
logic [63:0] alu_out;

logic [63:0] dmu_out;

logic [63:0] imm_out;

/*
    --- Register File ---
*/
logic reg_write;
register_file m_regs (
    .clk(clk),
    .read_a(rs1),
    .read_b(rs2),
    .write_en(reg_write),
    .write_sel(reg_sel),
    .data(dmu_out),
    
    .out_a(a_out),
    .out_b(b_out)
);

/*
    --- Immediate Generation Unit ---
*/
igu m_igu (
    .instr(instr),
    .imm_type(),
    
    .imm_out(imm_out)
);

/*
    --- Data Memory Unit ---
*/
logic mem_write, mem_read, mem_to_reg;
dmu m_dmu (
    .clk(clk),
    .write_en(mem_write),
    .read_en(mem_read),
    .addr(alu_out),
    .data_in(b_out),
    
    .data_out(dmu_out)
);

/*
    --- ALU ---
*/
logic [3:0] alu_op;
logic zero, carry, overflow;
alu c_alu (
    .alucontrol(alu_op),
    .rs1(a_out),
    .rs2(alu_b),

    .result(),
    .zero(),
    .carry(),
    .overflow()
);

/*
    --- ALU Control Unit ---
*/
alu_cont c_alu_cont (
    .funct7(funct7),
    .funct3(funct3),
    .aluop(),

    .alucontrol(alu_op)
);

/*
    --- Program Counter ---
*/
logic [31:0] pc_out;
logic [31:0] pc_inc;
counter #(.WIDTH(64)) m_pc (
    .clk(clk),
    .reset(reset),
    .inc()

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

assign alu_b = alu_src ? imm_out : b_out;
assign reg_data_in = mem_to_reg ? dmu_out : alu_out;

endmodule