module register #(
    parameter WIDTH = 8
) (
    input logic clk,
    input logic enable,
    input logic reset,
    input logic [WIDTH-1:0] data_in,

    output logic [WIDTH-1:0] data_out
);
    
always @(posedge(clk)) begin
    if (enable)
        data_out <= data_in;
end

always @(posedge(reset)) begin
    data_out <= {WIDTH{1'b0}};
end

endmodule
