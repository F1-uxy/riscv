// Branch Control Unit

module bcu (
    input logic [63:0] branch_rs1,
    input logic [63:0] branch_rs2,
    input logic [2:0] funct3,

    output logic branch_taken
);

always_comb begin
    case (funct3)
        3'b000: branch_taken = (branch_rs1 == branch_rs2);                      // beq
        3'b001: branch_taken = (branch_rs1 != branch_rs2);                      // bne
        3'b100: branch_taken = ($signed(branch_rs1) < $signed(branch_rs2));     // blt
        3'b101: branch_taken = ($signed(branch_rs1) >= $signed(branch_rs2));    // bge
        3'b110: branch_taken = (branch_rs1 < branch_rs2);                       // bltu
        3'b111: branch_taken = (branch_rs1 >= branch_rs2);                      // bgeu
        default: branch_taken = 1'b0;
    endcase
end
    
endmodule