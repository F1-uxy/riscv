// Branch Prediction Unit

module bpu (
    input logic branch,
    input logic taken,

    output logic [1:0] prediction
);

logic [1:0] curr_prediction;

initial curr_prediction = `PRED_NOT_TAKE;

always @(posedge(branch)) begin
    case (curr_prediction)
        `PRED_STRONG_TAKE:      curr_prediction <= taken ? curr_prediction :  `PRED_TAKE;
        `PRED_TAKE:             curr_prediction <= taken ? `PRED_STRONG_TAKE : `PRED_NOT_TAKE;
        `PRED_NOT_TAKE:         curr_prediction <= taken ? `PRED_TAKE : `PRED_STRONG_NOT_TAKE;
        `PRED_STRONG_NOT_TAKE:  curr_prediction <= taken ? `PRED_NOT_TAKE : curr_prediction;
        default: curr_prediction <= curr_prediction;
    endcase
end

assign prediction = curr_prediction;
    
endmodule