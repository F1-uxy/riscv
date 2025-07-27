module register #(
    parameter WIDTH = 8
) (
    input  logic clk,
    input  logic enable,
    input  logic reset,  // synchronous reset
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out
);

always_ff @(posedge clk) begin
    if (reset)
        data_out <= {WIDTH{1'b0}};
    else if (enable)
        data_out <= data_in;
end

endmodule
