// Branch Target Buffer

module btu (
    
    output 
);

typedef struct packed {
    logic valid;
    logic [1:0] tag;
    logic [1:0] index;
    logic [64:0] value;
} entry;
    
endmodule