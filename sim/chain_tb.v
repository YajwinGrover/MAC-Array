`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 05:33:35 PM
// Design Name: 
// Module Name: chain_tb
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


module chain_tb;

reg clk = 0;
always #5 clk = ~clk;
reg reset = 0;

reg signed [7:0]  a[7:0];
reg signed [63:0] a_flat;
reg signed [7:0]  b[7:0];
reg signed [63:0] b_flat;

reg data_valid = 0;
reg clear_accum = 0;

wire signed [127:0] accumalator;
wire                output_valid;
wire                overflow;

always @(*) begin 
    a_flat = {a[7],a[6],a[5],a[4],a[3],a[2],a[1],a[0]};
    b_flat = {b[7],b[6],b[5],b[4],b[3],b[2],a[1],b[0]};
end

chain dut(
    .clk(clk),
    .reset(reset),
    .a(a_flat),
    .b(b_flat),
    .data_valid(data_valid),
    .clear_accum(clear_accum),
    .accumalator(accumalator),
    .output_valid(output_valid),
    .overflow(overflow)
);

integer i;

initial begin
    $monitor("Dot: %d \nOverflow: %d", accumalator, overflow);
    for(i = 0; i < 8; i = i + 1) begin 
        a[i] = (-1)**i * i;
        b[i] = i;
    end
    #10
    data_valid = 1;
    #10000;
    $finish;
end
endmodule
