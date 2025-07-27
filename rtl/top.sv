module top ();
    
logic clk;
logic reset;

initial clk = 0;
    always #5 clk = ~clk;

endmodule