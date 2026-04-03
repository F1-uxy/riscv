// Branch Prediction Unit
`include "rtl/parameters.sv"

module bpu #(
    parameter ENTRIES = 64
)(
    input logic clk,
    input logic reset,
    input logic [63:0] pc_fetch,

    input logic update_en,
    input logic [63:0] pc_update,
    input logic taken,
    
    output logic prediction
);

localparam INDEX_BITS = $clog2(ENTRIES);

logic [INDEX_BITS-1:0] fetch_idx;
logic [INDEX_BITS-1:0] update_idx;

logic [1:0] pred_table [0:ENTRIES-1];

assign fetch_idx = pc_fetch[INDEX_BITS+1:2];
assign update_idx = pc_update[INDEX_BITS+1:2];

assign prediction = (pred_table[fetch_idx] >= `PRED_TAKE);

int idx;

always @(posedge(clk) or posedge(reset)) begin
    if (reset) begin
        for (idx = 0; idx < ENTRIES ; idx++) 
            pred_table[idx] <= `PRED_NOT_TAKE;
    end else if (update_en) begin
        case (pred_table[update_idx])
            `PRED_STRONG_TAKE: pred_table[update_idx] <= taken ? `PRED_STRONG_TAKE : `PRED_TAKE;
            `PRED_TAKE: pred_table[update_idx] <= taken ? `PRED_STRONG_TAKE : `PRED_NOT_TAKE;
            `PRED_NOT_TAKE: pred_table[update_idx] <= taken ? `PRED_TAKE : `PRED_STRONG_NOT_TAKE;
            `PRED_STRONG_NOT_TAKE: pred_table[update_idx] <= taken ? `PRED_NOT_TAKE  : `PRED_STRONG_NOT_TAKE;
        endcase
    end
end

endmodule
