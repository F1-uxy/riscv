// Instruction Memory

module instr_mem (
    input logic clk,
    input logic [63:0] addr,

    output logic [31:0] instruction
);

logic [31:0] mem [0:65535];

always_ff @( clk ) begin
    // Address must be word aligned
    instruction <= mem[addr[63:2]];
end
    
endmodule