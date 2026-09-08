`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 11:23:39 AM
// Design Name: 
// Module Name: MACArray
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

//Note: For some odd reason, Verilog needs flattened arrays as inputs
module MACArray(
    input clk,
    input reset,
    //Inputs: Eight ints, each 8 bits wide (8x8=64)
    input wire signed [63:0] a,
    input wire signed [63:0] b,
    input wire data_valid,
    //Output: Eight ints, each 16 bits wide (16x16=126)
    output wire signed [127:0] out,
    output reg output_valid
    );

    genvar i;
    generate
        for (i = 0;i < 8 ; i= i+1) begin
            MACLane lane(
                .clk(clk),
                .a(a[(i*8)+7:i*8]),
                .b(b[(i*8)+7:i*8]),
                .out(out[(i*16)+15:i*16])
            );
            
        end
    endgenerate

    //Wait one clock cycle to validate data because each MACLane is clocked but output is
    //sequential
    always @(posedge clk) begin 
        if(reset) begin 
            output_valid <= 0;
        end else begin 
            output_valid <= data_valid;
        end
    end
    
endmodule
