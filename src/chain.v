`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 02:21:52 PM
// Design Name: 
// Module Name: chain
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


module chain(
    input clk,
    input reset,
    //Inputs: Eight signed integers, 8 bits wide
    input wire signed [63:0] a,
    input wire signed [63:0] b,
    input wire data_valid,
    input wire clear_accum,
    //Able to accumalate up to 128 length vectors or 16 cycles of inputs
    output reg signed [127:0] accumalator = 0,
    output reg output_valid,
    output reg overflow
    
);

    reg signed [127:0]  sum;
    wire signed [127:0] mac_out;
    wire                mac_valid;
    wire signed [18:0]  adder_out;
    wire                adder_valid;

    MACArray array(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .data_valid(data_valid),
        .output_valid(mac_valid),
        .out(mac_out)
    );
    tree_adder adder(
        .clk(clk),
        .reset(reset),
        .a(mac_out),
        .data_valid(mac_valid),
        .out(adder_out),
        .output_valid(adder_valid)
    );
    wire signed [127:0] new_sum = adder_out + accumalator;
    wire would_overflow = (accumalator[127] == adder_out[18]) &&
                            (new_sum[127] != accumalator[127]);

    always @(posedge clk ) begin
        if(reset) begin 
            output_valid <= 0;
            accumalator <= 0;
            overflow <= 0;
        end else if(clear_accum) begin
            accumalator <= 0;
        end else begin 
            output_valid <= adder_valid;
            if(adder_valid) begin 
                overflow <= would_overflow;          
                accumalator <= new_sum;         
            end
        end
    end
endmodule
