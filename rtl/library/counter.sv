module counter #(
    parameter WIDTH = 8
) (
    input logic clk,
    input logic [WIDTH-1:0] inc,
    input logic reset,

    output logic [WIDTH-1:0] out
);

initial out = 0;

always @(posedge(clk) or posedge reset) begin
    if (reset) begin
        out <= {WIDTH{1'b0}};
    end else begin
        out <= out + inc;
    end
end

endmodule
