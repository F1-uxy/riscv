module forwarding_unit (
    input logic [4:0] ex_reg_rd,
    input logic       ex_reg_wr,
    input logic [4:0] mem_reg_rd,
    input logic       mem_reg_wr,
    input logic       id_rs1,
    input logic       id_rs2,

    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

always_comb begin
    // Forward A
    if (ex_reg_wr && (ex_reg_rd != 0) && (ex_reg_rd == id_rs1)) begin
        forward_a = 2'b10;
    end else if (mem_reg_wr && (mem_reg_rd != 0) && (mem_reg_rd == id_rs1)) begin
        forward_a = 2'b01;
    end else forward_a = 2'b00;

    // Forward B
    if (ex_reg_wr && (ex_reg_rd != 0) && (ex_reg_rd == id_rs2)) begin
        forward_b = 2'b10;
    end else if (mem_reg_wr && (mem_reg_rd != 0) && (mem_reg_rd == id_rs2)) begin
        forward_b = 2'b01;
    end else forward_b = 2'b00;
end



endmodule
