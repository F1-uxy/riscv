// Data Memory Unit

module dmu (
    input logic clk,
    input logic write_en,
    input logic read_en,

    input logic [2:0] funct3,
    input logic [15:0] addr,
    input logic [63:0] data_in,

    input logic [15:0] fwd_store_addr,
    input logic [63:0] fwd_store_data,
    input logic        fwd_store_en,

    output logic [63:0] data_out
);


logic [7:0] mem [65535:0] /* verilator public */;

// Load
always_comb begin
    if (read_en) begin
        if (fwd_store_en && (fwd_store_addr == addr)) begin
            data_out = fwd_store_data;
        end else begin
            case (funct3)
                3'b000: data_out = {{56{mem[addr][7]}}, mem[addr]};                                // LB
                3'b001: data_out = {{48{mem[addr+1][7]}}, mem[addr+1], mem[addr]};                 // LH
                3'b010: data_out = {{32{mem[addr+3][7]}}, mem[addr+3], mem[addr+2], 
                                                        mem[addr+1], mem[addr]};                   // LW
                3'b011: data_out = {mem[addr+7], mem[addr+6], mem[addr+5],                         // LD
                        mem[addr+4], mem[addr+3], mem[addr+2], 
                                    mem[addr+1], mem[addr]};
                3'b100: data_out = {{56{1'b0}}, mem[addr]};                                        // LBU
                3'b101: data_out = {{48{1'b0}}, mem[addr+1], mem[addr]};                           // LHU
                3'b110: data_out = {{32{1'b0}}, mem[addr+3], mem[addr+2], 
                                                mem[addr+1], mem[addr]};                           // LWU
                default: data_out = 64'b0;
            endcase
        end
    end else begin
        data_out = 64'b0;
    end
end

// Store
always @(posedge(clk)) begin
    if (write_en) begin
        case (funct3)
            3'b000: begin                               // SB
                mem[addr]   <= data_in[7:0];
            end
            3'b001: begin                               // SH
                mem[addr]   <= data_in[7:0];
                mem[addr+1] <= data_in[15:8];
            end
            3'b010: begin                               // SW
                mem[addr]   <= data_in[7:0];
                mem[addr+1] <= data_in[15:8];
                mem[addr+2] <= data_in[23:16];
                mem[addr+3] <= data_in[31:24];
            end
            3'b011: begin                               // SD
                mem[addr]   <= data_in[7:0];
                mem[addr+1] <= data_in[15:8];
                mem[addr+2] <= data_in[23:16];
                mem[addr+3] <= data_in[31:24];
                mem[addr+4] <= data_in[39:32];
                mem[addr+5] <= data_in[47:40];
                mem[addr+6] <= data_in[55:48];
                mem[addr+7] <= data_in[63:56];
            end
            default: ;
        endcase
    end
end
    
endmodule
