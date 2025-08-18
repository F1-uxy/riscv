module hdu (
    input logic       id_mem_rd,
    input logic [4:0] id_reg_sel,
    input logic       id_rs1,
    input logic       id_rs2,

    output logic stall
);

assign stall = (id_mem_rd && ((id_reg_sel == id_rs1) || (id_reg_sel == id_rs2)));

endmodule
