module hdu (
    input logic       id_mem_rd,
    input logic       ex_mem_rd,
    input logic [4:0] ex_reg_sel,
    input logic [4:0] id_reg_sel,
    input logic [4:0] id_rs1,
    input logic [4:0] id_rs2,

    output logic stall
);

logic id_hazard, ex_hazard;

assign id_hazard = id_mem_rd && (id_reg_sel != 0) &&
    ((id_reg_sel == id_rs1) || (id_reg_sel == id_rs2));

assign ex_hazard = ex_mem_rd && (ex_reg_sel != 0) &&
    ((ex_reg_sel == id_rs1) || (ex_reg_sel == id_rs2));

assign stall = id_hazard || ex_hazard;

endmodule
