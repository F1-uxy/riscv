module register_file (
    input  logic       clk,
    input logic [4:0]  read_a,
    input logic [4:0]  read_b,

    input logic        write_en,
    input logic [4:0]  write_sel,
    input logic [31:0] data,

    output logic [63:0] out_a,
    output logic [63:0] out_b,
);

logic [63:0] regs [31:0];

// Register x0 must always return 0 and is not writable
always_ff @(posedge clk) begin
        if (write_en && write_sel != 5'd0) begin
            regs[write_sel] <= data;
        end
    end

assign out_a = (read_a == 5'd0) ? 64'd0 : regs[read_a];
assign out_b = (read_b == 5'd0) ? 64'd0 : regs[read_b];


endmodule