`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 12:09:22 PM
// Design Name: 
// Module Name: tree_adder
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


module tree_adder(
    input clk,
    input reset,
    //8 signed integers, each 16 bits wide
    input wire signed [127:0] a,
    input wire data_valid,
    //One signed integer, 19 bits wide
    output reg signed [18:0] out,
    output reg output_valid

);
    //Put it into signed reg because slices are apparently unsigned *sigh*
    //Eight signed itegers, each 16 bits wide
    wire signed [15:0] level_0 [7:0];

    genvar i;
    generate 
        for(i = 0; i < 8; i=i+1) begin 
            assign level_0[i] = a[(i*16)+15 : i*16];
        end
    endgenerate

    //Four signed integers, each 17 bits wide
    reg signed [16:0] level_1 [3:0];
    reg               level_1_valid;
    always @(posedge clk) begin
        level_1[3] <= level_0[7] + level_0[6];
        level_1[2] <= level_0[5] + level_0[4];
        level_1[1] <= level_0[3] + level_0[2];
        level_1[0] <= level_0[1] + level_0[0];
        level_1_valid <= data_valid;
    end

    //Two signed integers, each 18 bits wide
    reg signed [17:0] level_2 [1:0];
    reg               level_2_valid;
    always @(posedge clk) begin
        level_2[1] <= level_1[3] + level_1[2];
        level_2[0] <= level_1[1] + level_1[0];
        level_2_valid <= level_1_valid; 

    end

    //Output: one signed integer, 19 bits wide
    always @(posedge clk) begin
        if(reset) begin 
            out <= 0;
            output_valid <= 0;
        end else begin 
            out <= level_2[1] + level_2[0];
            output_valid <= level_2_valid;
        end

    end


    
endmodule
