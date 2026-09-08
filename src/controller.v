`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 06:31:48 PM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input clk,
    input reset,
    input signed [255:0] a,
    input signed [255:0] b,
    input start,
    output reg output_ready,
    output wire overflow,
    output signed [127:0] dot_product
);

localparam IDLE = 0;
localparam STREAM = 1;
localparam WAIT = 2;
localparam DONE = 3;

localparam CHUNK_COUNT = 4;


reg [63:0] vec1_flat;
reg [63:0] vec2_flat;
reg        data_valid;
reg [2:0]  chunks_finished = 0;
wire       chain_valid;

reg [1:0] state = IDLE;
reg [1:0] chunk_counter = 0;

reg clear_accum = 0;

chain chain(
    .clk(clk),
    .reset(reset),
    .a(vec1_flat),
    .b(vec2_flat),
    .data_valid(data_valid),
    .clear_accum(clear_accum),
    .accumalator(dot_product),
    .output_valid(chain_valid),
    .overflow(overflow)
);

always @(posedge clk) begin
    if(reset) begin 
        state <= IDLE;
        output_ready <= 0;
        vec1_flat <= 0;
        vec2_flat <= 0;
        data_valid <= 0;
        chunk_counter <= 0;
        chunks_finished <= 0;
        clear_accum <= 0;
    end else begin 
        
        data_valid <= 0;
        clear_accum <= 0;
        
        if(chain_valid) begin 
            chunks_finished <= chunks_finished + 1;        
        end
        case(state) 
            IDLE: begin 
                if(start) begin 
                    output_ready <= 0;
                    state <= STREAM;
                end
            end
            STREAM: begin
                vec1_flat <= a[(chunk_counter*64) +: 64];
                vec2_flat <= b[(chunk_counter*64) +: 64];
                data_valid <= 1;
                if(chunk_counter == CHUNK_COUNT-1) begin 
                    chunk_counter <= 0;
                    state <= WAIT;
                end else begin 
                    chunk_counter <= chunk_counter + 1;
                end
            end
            WAIT: begin 
                if(chunks_finished == CHUNK_COUNT) begin 
                    state <= DONE;
                end
            end
            
            DONE: begin 
                output_ready <= 1;
                chunk_counter <= 0;
                data_valid <= 0;
                chunks_finished <= 0;
                clear_accum <= 1;
                if(start) begin 
                    state <= STREAM;
                end
                
            end
        endcase
    end

end

endmodule

