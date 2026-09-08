`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 11:19:53 AM
// Design Name: 
// Module Name: MACLane
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


module MACLane(
    input clk, 
    input wire signed [7:0] a,
    input wire signed [7:0] b,
    output reg signed [15:0] out
    );

    always @(posedge clk ) begin
        out <= a * b;
    end
    
endmodule
