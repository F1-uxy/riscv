// Instruction Memory

/* verilator lint_off UNUSEDSIGNAL */
module instr_mem (
    input logic clk,
    input logic [63:0] addr,

    output logic [31:0] instruction
);


logic [31:0] mem [0:65535];

initial begin
    $display("Loading rom.");
    //$readmemh("../roms/testbench.mem", mem);
    mem[0] = 32'h000640b7;

end

always_comb begin
    // Address must be word aligned
    instruction = mem[addr[17:2]];
end

endmodule
