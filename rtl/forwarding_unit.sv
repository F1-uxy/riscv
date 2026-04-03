module forwarding_unit (
    input logic [4:0] ex_reg_rd,
    input logic       ex_reg_wr,
    input logic [4:0] mem_reg_rd,
    input logic       mem_reg_wr,

    input logic [4:0] id_rs1,
    input logic [4:0] id_rs2,

    output logic [1:0] forward_a,
    output logic [1:0] forward_b,
    output logic       forward_id_rs1,
    output logic       forward_id_rs2

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

    forward_id_rs1 = (ex_reg_wr && (ex_reg_rd != 0) && (ex_reg_rd == id_rs1)) ||
                 (mem_reg_wr && (mem_reg_rd != 0) && (mem_reg_rd == id_rs1));

    forward_id_rs2 = (ex_reg_wr && (ex_reg_rd != 0) && (ex_reg_rd == id_rs2)) ||
                    (mem_reg_wr && (mem_reg_rd != 0) && (mem_reg_rd == id_rs2));

end



endmodule
