// Data Memory Unit

module dmu (
    input logic clk,
    input logic write_en,
    input logic read_en,

    input logic [11:0] addr,
    input logic [63:0] data_in,

    output logic [63:0] data_out,
);

logic [7:0] mem [0:65535]; // Tempory memory

always_comb begin
    if (read_en & !write_en) begin
        data_out = {mem[addr + 7], mem[addr + 6], 
                    mem[addr + 5], mem[addr + 4], 
                    mem[addr + 3], mem[addr + 2], 
                    mem[addr + 1], mem[addr + 0]}
    end else begin
        data_out = 64'b0;
    end
end

always @(posedge(clk)) begin
    if (write_en & !read_en) begin
        mem[addr + 0] <= data_in[7:0];
        mem[addr + 1] <= data_in[15:8];
        mem[addr + 2] <= data_in[23:16];
        mem[addr + 3] <= data_in[31:24];
        mem[addr + 4] <= data_in[39:32];
        mem[addr + 5] <= data_in[47:40];
        mem[addr + 6] <= data_in[55:48];
        mem[addr + 7] <= data_in[63:56];
    end
end
    
endmodule